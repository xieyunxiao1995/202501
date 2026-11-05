import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ScenesView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @EnvironmentObject private var workspace: WorkspaceState
    @Query(sort: \StoredScene.updatedAt, order: .reverse) private var records: [StoredScene]
    @State private var editorRecord: StoredScene?
    @State private var showingArchived = false
    @State private var gridLayout = true
    @State private var searchText = ""
    @State private var error: String?
    @State private var deleting: StoredScene?
    @State private var importing = false
    @State private var exportDocument: ExportFileDocument?
    @State private var exporting = false

    private var visible: [StoredScene] {
        records.filter { $0.isArchived == showingArchived &&
            (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)) }
        .sorted {
            if $0.isFavorite != $1.isFavorite { return $0.isFavorite }
            return $0.updatedAt > $1.updatedAt
        }
    }

    var body: some View {
        content
            .background(AppTheme.navy.ignoresSafeArea())
            .searchable(text: $searchText, prompt: "Search scenes")
            .navigationTitle("Scenes")
            .toolbar { toolbarContent }
            .sheet(item: $editorRecord) { record in
                SceneEditorView(record: record)
            }
            .confirmationDialog("Delete this scene?",
                                isPresented: deleteDialogPresented,
                                titleVisibility: .visible,
                                presenting: deleting) { record in
                Button("Delete Permanently", role: .destructive) { delete(record) }
            } message: { _ in
                Text("This cannot be undone unless you previously exported a project backup.")
            }
            .fileImporter(isPresented: $importing,
                          allowedContentTypes: [.json],
                          onCompletion: handleImport)
            .fileExporter(isPresented: $exporting,
                          document: exportDocument,
                          contentType: .json,
                          defaultFilename: "SunShadowPad-Scenes") { result in
                if case .failure(let failure) = result { error = failure.localizedDescription }
            }
            .alert("Unable to Complete Action",
                   isPresented: alertPresented) {
                Button("OK", role: .cancel) { error = nil }
            } message: {
                Text(error ?? "")
            }
            .task {
                #if DEBUG
                guard editorRecord == nil else { return }
                if UserDefaults.standard.bool(forKey: "newEmptyScene") {
                    try? await Task.sleep(for: .seconds(0.6))
                    if let blank = records.first(where: { $0.name == "New Outdoor Space" }) {
                        editorRecord = blank
                    } else {
                        addScene()
                    }
                    return
                }
                guard UserDefaults.standard.bool(forKey: "openFirstEditor") else { return }
                try? await Task.sleep(for: .seconds(0.8))
                editorRecord = records.first(where: { !$0.isArchived })
                #endif
            }
    }

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                Picker("Collection", selection: $showingArchived) {
                    Text("Active").tag(false)
                    Text("Archived").tag(true)
                }
                .pickerStyle(.segmented)
                sceneCollection
            }
            .padding(16)
        }
    }

    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button("Import Project", systemImage: "square.and.arrow.down") { importing = true }
                Button("Export All Scenes", systemImage: "square.and.arrow.up") { exportAll() }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .accessibilityLabel("Project options")
        }
    }

    private var deleteDialogPresented: Binding<Bool> {
        Binding(get: { deleting != nil }, set: { if !$0 { deleting = nil } })
    }

    private var alertPresented: Binding<Bool> {
        Binding(get: { error != nil }, set: { if !$0 { error = nil } })
    }

    private func handleImport(_ result: Result<URL, Error>) {
        do {
            let url = try result.get()
            let scoped = url.startAccessingSecurityScopedResource()
            defer { if scoped { url.stopAccessingSecurityScopedResource() } }
            let docs = try ProjectBackupService.importScenes(Data(contentsOf: url))
            _ = try ProjectBackupService.insertImported(docs, into: context, existing: records)
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func delete(_ record: StoredScene) {
        context.delete(record)
        try? context.save()
        deleting = nil
    }

    private var header: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) {
                headerTitle
                Spacer()
                headerButtons
            }
            VStack(alignment: .leading, spacing: 12) {
                headerTitle
                headerButtons
            }
        }
    }

    private var headerTitle: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(showingArchived ? "Archived Scenes" : "Your Spaces")
                .font(.title2.bold())
            Text("\(visible.count) local projects")
                .foregroundStyle(AppTheme.textMuted)
                .font(.subheadline)
        }
    }

    private var headerButtons: some View {
        HStack(spacing: 12) {
            Button { gridLayout.toggle() } label: {
                Image(systemName: gridLayout ? "list.bullet" : "square.grid.2x2")
            }
            .buttonStyle(.bordered)
            .accessibilityLabel(gridLayout ? "Switch to list" : "Switch to grid")
            Button { addScene() } label: { Image(systemName: "plus") }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel("Create scene")
        }
    }

    @ViewBuilder
    private var sceneCollection: some View {
        if visible.isEmpty {
            if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                ContentUnavailableView.search(text: searchText)
                    .padding(.top, 25)
            } else if showingArchived {
                ContentUnavailableView("No Archived Scenes", systemImage: "archivebox",
                                       description: Text("Archived projects stay on this device and can be restored at any time."))
                    .padding(.top, 25)
            } else {
                ContentUnavailableView {
                    Label("No Spaces Here", systemImage: "sun.max")
                } description: {
                    Text("Create a scene to start modelling sunlight.")
                } actions: {
                    Button("Create Scene") { addScene() }
                        .buttonStyle(.borderedProminent)
                }
                .padding(.top, 25)
            }
        } else if gridLayout && !dynamicTypeSize.isAccessibilitySize {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)], spacing: 12) {
                ForEach(visible) { record in sceneCard(record) }
            }
        } else {
            LazyVStack(spacing: 10) {
                ForEach(visible) { record in sceneRow(record) }
            }
        }
    }

    private func sceneCard(_ record: StoredScene) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Button { open(record) } label: {
                VStack(alignment: .leading, spacing: 10) {
                    SceneCanvasView(scene: record.document,
                                    moment: TimeService.localInstant(on: workspace.inspectionDate,
                                                                     minutes: 840,
                                                                     in: record.document.timeZoneID),
                                    showsGrid: false)
                        .frame(height: 140)
                        .allowsHitTesting(false)
                        .overlay(alignment: .topLeading) {
                            if isCurrent(record) { currentBadge }
                        }
                    HStack {
                        Text(record.name).font(.subheadline.bold()).lineLimit(1)
                        Spacer(minLength: 4)
                        if record.isFavorite {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.yellow)
                                .accessibilityLabel("Favorite")
                        }
                    }
                    Text(record.category).font(.caption).foregroundStyle(AppTheme.textMuted)
                    HStack(spacing: 10) {
                        Label("\(record.document.elements.count)", systemImage: "square.3.layers.3d")
                            .accessibilityLabel("\(record.document.elements.count) objects")
                        Label("\(record.document.targets.count)", systemImage: "scope")
                            .accessibilityLabel("\(record.document.targets.count) observation areas")
                        Spacer(minLength: 0)
                        Text(record.updatedAt, format: .dateTime.month(.abbreviated).day())
                    }
                    .font(.caption2)
                    .foregroundStyle(AppTheme.textMuted)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(accessibilitySummary(record))
            .accessibilityHint(openHint(record))
            .accessibilityIdentifier("sceneOpen")

            HStack(spacing: 14) {
                if record.isArchived {
                    Button { restore(record) } label: { Label("Restore", systemImage: "arrow.uturn.backward") }
                        .font(.caption.bold())
                } else {
                    Button { open(record) } label: { Label("Simulate", systemImage: "play.fill") }
                        .font(.caption.bold())
                }
                Spacer()
                editButton(record)
                contextMenuItems(record)
            }.foregroundStyle(AppTheme.yellow)
        }
        .padding(11)
        .background(AppTheme.panel, in: RoundedRectangle(cornerRadius: 18))
    }

    private func sceneRow(_ record: StoredScene) -> some View {
        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: 10) {
                    Button { open(record) } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            rowThumbnail(record)
                                .frame(height: 96)
                                .overlay(alignment: .topLeading) {
                                    if isCurrent(record) { currentBadge }
                                }
                            rowDetails(record)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(accessibilitySummary(record))
                    .accessibilityHint(openHint(record))
                    .accessibilityIdentifier("sceneOpen")
                    HStack(spacing: 16) {
                        if record.isArchived {
                            Button { restore(record) } label: { Label("Restore", systemImage: "arrow.uturn.backward") }
                                .font(.caption.bold())
                                .foregroundStyle(AppTheme.yellow)
                        }
                        Spacer()
                        editButton(record)
                        contextMenuItems(record)
                    }
                }
            } else {
                HStack(spacing: 12) {
                    Button { open(record) } label: {
                        HStack(spacing: 12) {
                            rowThumbnail(record)
                                .frame(width: 85, height: 72)
                                .overlay(alignment: .topLeading) {
                                    if isCurrent(record) {
                                        Image(systemName: "sun.max.fill")
                                            .font(.caption2)
                                            .foregroundStyle(AppTheme.yellow)
                                            .padding(3)
                                    }
                                }
                            rowDetails(record)
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(AppTheme.textMuted)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(accessibilitySummary(record))
                    .accessibilityHint(openHint(record))
                    .accessibilityIdentifier("sceneOpen")
                    editButton(record)
                    contextMenuItems(record)
                }
            }
        }
        .padding(12)
        .background(AppTheme.panel, in: RoundedRectangle(cornerRadius: 16))
    }

    private func rowThumbnail(_ record: StoredScene) -> some View {
        SceneCanvasView(scene: record.document,
                        moment: TimeService.localInstant(on: workspace.inspectionDate,
                                                         minutes: 840,
                                                         in: record.document.timeZoneID),
                        showsGrid: false)
            .allowsHitTesting(false)
    }

    private func rowDetails(_ record: StoredScene) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(record.name).font(.headline)
            Text(record.category).font(.caption).foregroundStyle(AppTheme.textMuted)
            Text("\(record.document.elements.count) objects • \(record.document.targets.count) areas • \(record.updatedAt.formatted(.dateTime.month(.abbreviated).day()))")
                .font(.caption2).foregroundStyle(AppTheme.textMuted)
            Label(record.isArchived ? "Open in Editor" : "Open in Simulator",
                  systemImage: record.isArchived ? "pencil.circle" : "play.circle")
                .font(.caption.bold())
                .foregroundStyle(AppTheme.yellow)
        }
    }

    private var currentBadge: some View {
        Label("Current", systemImage: "sun.max.fill")
            .font(.caption2.bold())
            .foregroundStyle(AppTheme.navy)
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
            .background(AppTheme.yellow, in: Capsule())
            .padding(8)
    }

    /// Mirrors the Simulator's fallback so the badge never lies about what is on screen.
    private func isCurrent(_ record: StoredScene) -> Bool {
        guard !record.isArchived else { return false }
        let effective = records.first { $0.id == workspace.selectedSceneID && !$0.isArchived }?.id
            ?? records.first { !$0.isArchived }?.id
        return record.id == effective
    }

    private func accessibilitySummary(_ record: StoredScene) -> String {
        var parts = [record.name, record.category,
                     "\(record.document.elements.count) objects",
                     "\(record.document.targets.count) observation areas"]
        if record.isFavorite { parts.append("favorite") }
        if record.isArchived { parts.append("archived") }
        if isCurrent(record) { parts.append("currently shown in Shadow Simulator") }
        return parts.joined(separator: ", ")
    }

    private func openHint(_ record: StoredScene) -> String {
        record.isArchived
            ? "Opens this archived scene in the editor"
            : "Opens this scene in Shadow Simulator"
    }

    private func open(_ record: StoredScene) {
        if record.isArchived {
            editorRecord = record
        } else {
            workspace.select(record)
        }
    }

    private func restore(_ record: StoredScene) {
        record.isArchived = false
        try? context.save()
        showingArchived = false
    }

    private func editButton(_ record: StoredScene) -> some View {
        Button { editorRecord = record } label: {
            Image(systemName: "pencil").frame(minWidth: 28, minHeight: 28)
        }
        .contentShape(Rectangle())
        .accessibilityLabel("Edit \(record.name)")
    }

    private func contextMenuItems(_ record: StoredScene) -> some View {
        Menu {
            Button(record.isFavorite ? "Remove Favorite" : "Favorite", systemImage: "star") {
                record.isFavorite.toggle(); try? context.save()
            }
            Button("Duplicate as New Layout", systemImage: "square.on.square") {
                let copy = record.document.copyAs(record.name + " — Alternative")
                let duplicate = StoredScene(document: copy)
                context.insert(duplicate)
                try? context.save()
                workspace.selectedSceneID = duplicate.id
            }
            Button(record.isArchived ? "Restore" : "Archive", systemImage: "archivebox") {
                record.isArchived.toggle(); try? context.save()
            }
            Button("Export JSON", systemImage: "square.and.arrow.up") {
                do { exportDocument = ExportFileDocument(bytes: try ProjectBackupService.json(for: record.document)); exporting = true }
                catch let failure { error = failure.localizedDescription }
            }
            Button("Delete", systemImage: "trash", role: .destructive) { deleting = record }
        } label: {
            Image(systemName: "ellipsis").frame(minWidth: 28, minHeight: 28)
        }
            .contentShape(Rectangle())
            .accessibilityLabel("More actions for \(record.name)")
    }

    private func addScene() {
        let doc = SceneDocument.blank()
        let row = StoredScene(document: doc)
        context.insert(row)
        try? context.save()
        editorRecord = row
        workspace.selectedSceneID = row.id
    }

    private func exportAll() {
        do {
            exportDocument = ExportFileDocument(bytes: try ProjectBackupService.exportAll(records))
            exporting = true
        } catch let failure { error = failure.localizedDescription }
    }
}
