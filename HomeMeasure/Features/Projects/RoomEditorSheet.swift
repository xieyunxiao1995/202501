import SwiftUI
import PhotosUI

struct RoomEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let existing: RoomPlan?
    let onSave: (RoomPlan) -> String?

    @State private var name: String
    @State private var length: Double
    @State private var width: Double
    @State private var height: Double
    @State private var openings: [RoomOpening]
    @State private var notes: String
    @State private var photoFilename: String?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isLoadingPhoto = false
    @State private var photoSelectionRevision = 0
    @State private var photoError: String?
    @State private var saved = false
    @State private var saveError: String?

    init(existing: RoomPlan? = nil, onSave: @escaping (RoomPlan) -> String?) {
        self.existing = existing; self.onSave = onSave
        _name = State(initialValue: existing?.name ?? "")
        _length = State(initialValue: existing?.length ?? 4)
        _width = State(initialValue: existing?.width ?? 3)
        _height = State(initialValue: existing?.height ?? 2.7)
        _openings = State(initialValue: existing?.openings ?? [])
        _notes = State(initialValue: existing?.notes ?? "")
        _photoFilename = State(initialValue: existing?.photoFilename)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Room") {
                    TextField("Room name", text: $name)
                    measurement("Length (m)", value: $length)
                    measurement("Width (m)", value: $width)
                    measurement("Height (m)", value: $height)
                }
                Section("Doors and windows") {
                    ForEach($openings) { $opening in
                        VStack(alignment: .leading, spacing: 10) {
                            Picker("Opening type", selection: $opening.kind) {
                                ForEach(OpeningType.allCases) { kind in
                                    Text(kind.rawValue).tag(kind)
                                }
                            }
                            measurement("Width (m)", value: $opening.width)
                            measurement("Height (m)", value: $opening.height)
                            Stepper("Quantity: \(opening.count)", value: $opening.count, in: 1...30)
                        }.padding(.vertical, 5)
                    }.onDelete { openings.remove(atOffsets: $0) }
                    Button { openings.append(RoomOpening()) } label: {
                        Label("Add Door or Window", systemImage: "plus.circle")
                    }
                }
                Section("Room photo") {
                    if let image = RoomPhotoService.image(photoFilename) {
                        Image(uiImage: image).resizable().scaledToFill().frame(height: 150)
                            .frame(maxWidth: .infinity).clipped().clipShape(RoundedRectangle(cornerRadius: 12))
                            .accessibilityLabel("Selected room photo")
                    }
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Label("Choose Photo", systemImage: "photo.on.rectangle")
                    }
                    if isLoadingPhoto { ProgressView("Loading photo…") }
                    if photoFilename != nil {
                        Button("Remove Photo", role: .destructive) {
                            selectedPhoto = nil
                            isLoadingPhoto = false
                            discardTemporaryPhoto()
                            photoFilename = nil
                        }
                    }
                }
                Section("Calculated measurements") {
                    if let preview = measuresPreview {
                        LabeledContent("Floor area", value: EstimationService.measure(preview.floor))
                        LabeledContent("Net wall area", value: EstimationService.measure(preview.wallNet))
                        LabeledContent("Baseboard", value: EstimationService.measure(preview.baseboardLength, unit: "m"))
                    } else {
                        Text("Enter dimensions above to preview measurements.")
                            .foregroundStyle(.secondary)
                    }
                }
                if !isValid {
                    Section { Text("Enter a room name and dimensions greater than 0 and no more than 1,000 m. Opening dimensions must also be within this range.").foregroundStyle(.red) }
                }
                Section("Notes") { TextField("Room details", text: $notes, axis: .vertical).lineLimit(2...5) }
                Section {
                    Text("All dimensions are measured in meters. Doors and windows are subtracted from the wall area; door widths are deducted from baseboard length.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .navigationTitle(existing == nil ? "Add Room" : "Edit Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }.fontWeight(.semibold).disabled(!isValid || isLoadingPhoto)
                }
            }
            .onChange(of: selectedPhoto) { _, item in
                isLoadingPhoto = item != nil
                photoSelectionRevision += 1
            }
            .task(id: photoSelectionRevision) {
                guard let selectedPhoto else { return }
                let revision = photoSelectionRevision
                defer { if photoSelectionRevision == revision { isLoadingPhoto = false } }
                do {
                    if let data = try await selectedPhoto.loadTransferable(type: Data.self) {
                        try Task.checkCancellation()
                        let newFilename = try RoomPhotoService.save(data)
                        if Task.isCancelled { RoomPhotoService.delete(newFilename); return }
                        discardTemporaryPhoto()
                        photoFilename = newFilename
                    } else {
                        try Task.checkCancellation()
                        photoError = "The selected image could not be loaded. Please choose another image."
                        self.selectedPhoto = nil
                    }
                } catch is CancellationError {
                    // A newer selection or dismissal superseded this request.
                } catch {
                    if photoSelectionRevision == revision {
                        photoError = error.localizedDescription
                        self.selectedPhoto = nil
                    }
                }
            }
            .onDisappear { if !saved { discardTemporaryPhoto() } }
            .alert("Unable to save room", item: $saveError) { _ in
                Button("OK", role: .cancel) { }
            } message: { message in
                Text(message)
            }
            .alert("Photo could not be added", item: $photoError) { _ in
                Button("OK", role: .cancel) { }
            } message: { message in
                Text(message)
            }
        }.tint(AppTheme.slate)
    }
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && [length, width, height].allSatisfy { $0.isFinite && $0 > 0 && $0 <= 1000 }
            && openings.allSatisfy { $0.width.isFinite && $0.height.isFinite
                && $0.width > 0 && $0.width <= 1000 && $0.height > 0 && $0.height <= 1000 && (1...30).contains($0.count) }
    }
    private var measuresPreview: RoomMeasures? {
        guard [length, width, height].allSatisfy({ $0.isFinite && $0 > 0 && $0 <= 1000 }) else { return nil }
        return EstimationService.room(RoomPlan(name: name, length: length, width: width, height: height, openings: openings))
    }
    private func measurement(_ label: String, value: Binding<Double>) -> some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading)) : AnyLayout(HStackLayout())
        return layout {
            Text(label)
            if !dynamicTypeSize.isAccessibilitySize { Spacer() }
            TextField("0.00", value: value, format: .number.precision(.fractionLength(0...2)))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(dynamicTypeSize.isAccessibilitySize ? .leading : .trailing)
                .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : 100)
                .accessibilityLabel(label)
        }
    }
    private func discardTemporaryPhoto() {
        if photoFilename != existing?.photoFilename { RoomPhotoService.delete(photoFilename) }
    }
    private func save() {
        var room = existing ?? RoomPlan(name: name, length: length, width: width, height: height)
        room.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        room.length = length; room.width = width; room.height = height
        room.openings = openings; room.notes = notes; room.photoFilename = photoFilename
        if let error = onSave(room) {
            saveError = error
        } else {
            if existing?.photoFilename != photoFilename { RoomPhotoService.delete(existing?.photoFilename) }
            saved = true
            dismiss()
        }
    }
}
