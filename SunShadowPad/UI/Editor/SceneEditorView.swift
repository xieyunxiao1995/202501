import SwiftUI
import SwiftData

struct SceneEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var workspace: WorkspaceState
    let record: StoredScene
    @State private var document: SceneDocument
    @State private var selectedElementID: UUID?
    @State private var selectedTargetID: UUID?
    @State private var showingInfo = false
    @State private var showingLayers = false
    @State private var showingInspector = false
    @State private var history: [SceneDocument] = []
    @State private var redoHistory: [SceneDocument] = []
    @AppStorage("editorViewMode") private var viewMode: SceneViewMode = .threeD

    init(record: StoredScene) {
        self.record = record
        _document = State(initialValue: record.document)
    }

    private var moment: Date {
        TimeService.localInstant(on: workspace.inspectionDate,
                                 minutes: Int(workspace.minuteOfDay), in: document.timeZoneID)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    Label("\(document.width.formatted(.number.precision(.fractionLength(1)))) × \(document.height.formatted(.number.precision(.fractionLength(1)))) m", systemImage: "ruler")
                    Spacer()
                    Label("\(document.elements.count) obstacles", systemImage: "square.3.layers.3d")
                }
                .font(.caption).foregroundStyle(AppTheme.textMuted).padding(.horizontal, 8)

                Group {
                    if viewMode == .threeD {
                        Scene3DView(scene: document, moment: moment, allowsEditing: true,
                                    selectedElement: selectedElementID,
                                    selectedTarget: selectedTargetID,
                                    onSelectElement: selectElement,
                                    onSelectTarget: selectTarget,
                                    onMoveElement: placeElement,
                                    onMoveTarget: placeTarget)
                    } else {
                        SceneCanvasView(scene: document, moment: moment, selectedElement: selectedElementID,
                                        allowsInteraction: true,
                                        onSelectElement: { id in
                            selectedElementID = id; selectedTargetID = nil; showingInspector = true
                        }, onSelectTarget: { id in
                            selectedTargetID = id; selectedElementID = nil; showingInspector = true
                        }, onMoveElement: { id, dx, dy in
                            mutate { doc in
                                guard let index = doc.elements.firstIndex(where: { $0.id == id }) else { return }
                                doc.elements[index].x = min(doc.width, max(0, doc.elements[index].x + dx))
                                doc.elements[index].y = min(doc.height, max(0, doc.elements[index].y + dy))
                            }
                        }, onMoveTarget: { id, dx, dy in
                            mutate { doc in
                                guard let index = doc.targets.firstIndex(where: { $0.id == id }) else { return }
                                doc.targets[index].x = min(doc.width, max(0, doc.targets[index].x + dx))
                                doc.targets[index].y = min(doc.height, max(0, doc.targets[index].y + dy))
                            }
                        })
                    }
                }
                .frame(maxHeight: .infinity)
                .overlay(alignment: .bottomTrailing) {
                    SceneViewModeToggle(mode: $viewMode).padding(10)
                }
                .overlay {
                    if document.elements.isEmpty {
                        VStack(spacing: 7) {
                            Image(systemName: "square.dashed")
                                .font(.title2).foregroundStyle(AppTheme.yellow)
                            Text(document.targets.isEmpty ? "Start With Your Space" : "No Obstacles Yet")
                                .font(.headline)
                            Text(document.targets.isEmpty
                                 ? "Use Add Object to place a wall, tree or observation area."
                                 : "Add an object to model how its shadow crosses the site.")
                                .font(.caption).foregroundStyle(AppTheme.textMuted)
                                .multilineTextAlignment(.center)
                        }
                        .padding(16)
                        .background(AppTheme.navy.opacity(0.82), in: RoundedRectangle(cornerRadius: 16))
                        .padding(24)
                        .allowsHitTesting(false)
                    }
                }

                HStack(spacing: 7) {
                    toolMenu
                    Button { showingLayers = true } label: {
                        Label("Layers", systemImage: "square.3.layers.3d")
                    }.buttonStyle(.bordered)
                    Spacer(minLength: 0)
                    Button { undo() } label: { Image(systemName: "arrow.uturn.backward") }
                        .disabled(history.isEmpty).accessibilityLabel("Undo")
                    Button { redo() } label: { Image(systemName: "arrow.uturn.forward") }
                        .disabled(redoHistory.isEmpty).accessibilityLabel("Redo")
                }.controlSize(.small)
                Surface {
                    HStack {
                        Image(systemName: viewMode == .threeD ? "cube.transparent" : "hand.draw")
                            .foregroundStyle(AppTheme.yellow)
                        Text(viewMode == .threeD
                             ? "Tap to inspect • Drag objects to move • Drag empty ground to orbit"
                             : "Tap to edit • Drag to move • Pinch to zoom")
                            .font(.caption).foregroundStyle(AppTheme.textMuted)
                    }
                }
            }
            .padding(12)
            .background(AppTheme.navy.ignoresSafeArea())
            .navigationTitle(document.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button { showingInfo = true } label: { Image(systemName: "slider.horizontal.3") }
                        .accessibilityLabel("Scene properties")
                    Button { viewShadows() } label: { Image(systemName: "sun.max") }
                        .accessibilityLabel("View shadows in simulator")
                }
            }
            .sheet(isPresented: $showingInfo) { sceneInfoSheet }
            .sheet(isPresented: $showingLayers) { layerSheet }
            .sheet(isPresented: $showingInspector) { inspectorSheet }
            .onChange(of: document) { _, _ in persist() }
            .onDisappear { persist() }
        }
    }

    private var toolMenu: some View {
        Menu {
            Section("Obstacles") {
                ForEach(ElementKind.allCases) { kind in
                    Button { addElement(kind) } label: {
                        Label(kind.rawValue, systemImage: kind.symbol)
                    }
                }
            }
            Section("Observation & Planting") {
                ForEach(TargetKind.allCases) { kind in
                    Button(kind.rawValue) { addTarget(kind) }
                }
            }
        } label: { Label("Add Object", systemImage: "plus.square.on.square") }
            .buttonStyle(.borderedProminent)
    }

    private var sceneInfoSheet: some View {
        NavigationStack {
            Form {
                Section("Project") {
                    TextField("Scene Name", text: $document.name)
                    Picker("Category", selection: $document.kind) {
                        ForEach(SceneKind.allCases) { kind in Text(kind.rawValue).tag(kind) }
                    }
                    TextField("Notes", text: $document.notes, axis: .vertical)
                }
                Section("Location & Orientation") {
                    LabeledContent("Latitude") { TextField("Degrees", value: $document.latitude, format: .number)
                        .multilineTextAlignment(.trailing).keyboardType(.numbersAndPunctuation) }
                    LabeledContent("Longitude") { TextField("Degrees", value: $document.longitude, format: .number)
                        .multilineTextAlignment(.trailing).keyboardType(.numbersAndPunctuation) }
                    TextField("IANA Time Zone", text: $document.timeZoneID)
                        .textInputAutocapitalization(.never).autocorrectionDisabled()
                    if TimeZone(identifier: document.timeZoneID) == nil {
                        Text("Enter a valid IANA identifier, for example Europe/London.")
                            .foregroundStyle(.orange).font(.caption)
                    }
                    HStack {
                        Text("True North")
                        Spacer()
                        Text("\(Int(document.northDegrees))°").foregroundStyle(AppTheme.yellow)
                    }
                    Slider(value: $document.northDegrees, in: 0...359, step: 1)
                }
                Section("Site Dimensions · Metres") {
                    LabeledContent("Width") { TextField("Width", value: $document.width, format: .number)
                        .multilineTextAlignment(.trailing).keyboardType(.decimalPad) }
                    LabeledContent("Depth") { TextField("Depth", value: $document.height, format: .number)
                        .multilineTextAlignment(.trailing).keyboardType(.decimalPad) }
                }
                if !document.isValid {
                    Text("Keep latitude within ±90°, longitude within ±180°, dimensions between 1 and 2,000 m, and choose a valid time zone.")
                        .foregroundStyle(.orange).font(.caption)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Scene Properties")
            .toolbar { ToolbarItem(placement: .confirmationAction) {
                Button("Done") { showingInfo = false }.disabled(!document.isValid)
            } }
        }
    }

    private var layerSheet: some View {
        NavigationStack {
            List {
                Section("Objects") {
                    ForEach(document.elements) { element in
                        Button {
                            selectedElementID = element.id; selectedTargetID = nil
                            showingLayers = false
                            DispatchQueue.main.async { showingInspector = true }
                        } label: {
                            HStack {
                                Image(systemName: element.kind.symbol)
                                Text(element.name)
                                Spacer()
                                if element.isHidden { Image(systemName: "eye.slash") }
                                if element.isLocked { Image(systemName: "lock.fill") }
                            }
                        }
                    }
                }
                Section("Observation Areas") {
                    ForEach(document.targets) { target in
                        Button {
                            selectedTargetID = target.id; selectedElementID = nil
                            showingLayers = false
                            DispatchQueue.main.async { showingInspector = true }
                        } label: { Label(target.name, systemImage: "scope") }
                    }
                }
            }
            .navigationTitle("Layers")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { showingLayers = false } } }
        }
    }

    @ViewBuilder
    private var inspectorSheet: some View {
        if let id = selectedElementID, let i = document.elements.firstIndex(where: { $0.id == id }) {
            ElementInspector(element: $document.elements[i], onDuplicate: {
                let copy = document.elements[i]
                mutate { doc in
                    var new = copy
                    new.id = UUID(); new.name += " Copy"; new.x = min(doc.width, new.x + 0.6)
                    doc.elements.append(new)
                }
                showingInspector = false
            }, onDelete: {
                mutate { $0.elements.removeAll { $0.id == id } }
                selectedElementID = nil; showingInspector = false
            })
        } else if let id = selectedTargetID, let i = document.targets.firstIndex(where: { $0.id == id }) {
            TargetInspector(target: $document.targets[i], onDelete: {
                mutate { $0.targets.removeAll { $0.id == id } }
                selectedTargetID = nil; showingInspector = false
            })
        } else { EmptyView() }
    }

    private func selectElement(_ id: UUID) {
        selectedElementID = id
        selectedTargetID = nil
        showingInspector = true
    }

    private func selectTarget(_ id: UUID) {
        selectedTargetID = id
        selectedElementID = nil
        showingInspector = true
    }

    private func placeElement(_ id: UUID, x: Double, y: Double) {
        mutate { doc in
            guard let index = doc.elements.firstIndex(where: { $0.id == id }) else { return }
            let site = Scene3DMath.clampToSite(x, y, width: doc.width, height: doc.height)
            doc.elements[index].x = site.x
            doc.elements[index].y = site.y
        }
    }

    private func placeTarget(_ id: UUID, x: Double, y: Double) {
        mutate { doc in
            guard let index = doc.targets.firstIndex(where: { $0.id == id }) else { return }
            let site = Scene3DMath.clampToSite(x, y, width: doc.width, height: doc.height)
            doc.targets[index].x = site.x
            doc.targets[index].y = site.y
        }
    }

    private func addElement(_ kind: ElementKind) {
        let item = SceneElement.make(kind, in: document)
        mutate { $0.elements.append(item) }
        selectedElementID = item.id; selectedTargetID = nil
        showingInspector = true
    }
    private func addTarget(_ kind: TargetKind) {
        let number = document.targets.filter { $0.kind == kind }.count + 1
        let item = ObservationTarget(name: "\(kind.rawValue) \(number)", kind: kind,
                                     x: document.width / 2, y: document.height / 2,
                                     width: kind == .observation ? 0 : 3,
                                     depth: kind == .observation ? 0 : 2)
        mutate { $0.targets.append(item) }
        selectedTargetID = item.id; selectedElementID = nil
        showingInspector = true
    }
    private func mutate(_ change: (inout SceneDocument) -> Void) {
        history.append(document)
        if history.count > 50 { history.removeFirst() }
        redoHistory.removeAll()
        change(&document)
    }
    private func undo() {
        guard let earlier = history.popLast() else { return }
        redoHistory.append(document); document = earlier
    }
    private func redo() {
        guard let next = redoHistory.popLast() else { return }
        history.append(document); document = next
    }
    private func persist() {
        guard document.isValid else { return }
        record.update(with: document)
        try? context.save()
        workspace.forceRefresh = UUID()
    }

    private func viewShadows() {
        persist()
        workspace.select(record)
        dismiss()
    }
}
