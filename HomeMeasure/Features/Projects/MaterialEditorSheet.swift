import SwiftUI

struct MaterialEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let rooms: [RoomPlan]
    let currencyCode: String
    let existing: MaterialPlan?
    let onSave: (MaterialPlan) -> String?

    @State private var name: String
    @State private var roomID: UUID
    @State private var category: MaterialCategory
    @State private var surface: MaterialSurface
    @State private var coveragePerPack: Double
    @State private var packUnit: String
    @State private var unitPrice: Double
    @State private var wastePercent: Double
    @State private var coats: Int
    @State private var manualQuantity: Double
    @State private var overrideEnabled: Bool
    @State private var overridePacks: Int
    @State private var notes: String
    @State private var saveError: String?

    init(rooms: [RoomPlan], currencyCode: String, existing: MaterialPlan? = nil,
         onSave: @escaping (MaterialPlan) -> String?) {
        self.rooms = rooms
        self.currencyCode = currencyCode
        self.existing = existing
        self.onSave = onSave
        _name = State(initialValue: existing?.name ?? "")
        _roomID = State(initialValue: existing?.roomID ?? rooms.first?.id ?? UUID())
        _category = State(initialValue: existing?.category ?? .tile)
        _surface = State(initialValue: existing?.surface ?? .floor)
        _coveragePerPack = State(initialValue: existing?.coveragePerPack ?? 1.44)
        _packUnit = State(initialValue: existing?.packUnit ?? "boxes")
        _unitPrice = State(initialValue: existing?.unitPrice ?? 0)
        _wastePercent = State(initialValue: existing?.wastePercent ?? 10)
        _coats = State(initialValue: existing?.coats ?? 1)
        _manualQuantity = State(initialValue: existing?.manualQuantity ?? 1)
        _overrideEnabled = State(initialValue: existing?.overridePacks != nil)
        _overridePacks = State(initialValue: existing?.overridePacks ?? 1)
        _notes = State(initialValue: existing?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Material") {
                    TextField("Material name", text: $name)
                    Picker("Category", selection: $category) {
                        ForEach(MaterialCategory.allCases) { Text($0.rawValue).tag($0) }
                    }
                    Picker("Room", selection: $roomID) {
                        ForEach(rooms) { Text($0.name).tag($0.id) }
                    }
                    Picker("Measure", selection: $surface) {
                        ForEach(MaterialSurface.allCases) { Text($0.rawValue).tag($0) }
                    }
                }
                Section("Coverage and waste") {
                    if surface == .manual {
                        numberInput("Required units", value: $manualQuantity)
                    }
                    numberInput("Coverage per package (\(surface.unit))", value: $coveragePerPack)
                    TextField("Package label (e.g. boxes)", text: $packUnit)
                    numberInput("Waste allowance (%)", value: $wastePercent)
                    Stepper("Layers / coats: \(coats)", value: $coats, in: 1...10)
                }
                Section("Cost and purchase") {
                    numberInput("Price per package", value: $unitPrice)
                    Toggle("Override calculated packages", isOn: $overrideEnabled)
                    if overrideEnabled {
                        Stepper("Packages to buy: \(overridePacks)", value: $overridePacks, in: 0...1_000_000)
                    }
                }
                Section("Calculation preview") {
                    if let preview {
                        if preview.quantityExceedsLimit {
                            Text("The calculated quantity is too large to display. Check coverage per package or set an override.")
                                .foregroundStyle(.red)
                        } else {
                            LabeledContent("Quantity to buy", value: quantityText(preview))
                            LabeledContent("Required", value: EstimationService.measure(preview.requiredQuantity, unit: surface.unit))
                            LabeledContent("Estimated cost", value: EstimationService.money(preview.cost, code: currencyCode))
                        }
                    } else {
                        Text("Complete the fields above to see an estimate.")
                            .foregroundStyle(.secondary)
                    }
                }
                if !isValid {
                    Section {
                        Text("Enter a name and package label; coverage must be greater than 0 and at most 1,000,000. Price and quantity must be 0 to 1,000,000,000, and waste 0 to 100%.")
                            .foregroundStyle(.red)
                    }
                }
                Section("Notes") {
                    TextField("Finish, supplier, size or color", text: $notes, axis: .vertical)
                        .lineLimit(2...5)
                }
                Section {
                    Text("Packages = round up [(measured quantity × coats × (1 + waste %)) / coverage per package]. Enter usable coverage, after considering product labels and cutting patterns.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(existing == nil ? "Add Material" : "Edit Material")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }.fontWeight(.semibold).disabled(!isValid)
                }
            }
            .alert("Unable to save material", item: $saveError) { _ in
                Button("OK", role: .cancel) { }
            } message: { message in
                Text(message)
            }
            .onChange(of: category) { _, newValue in
                guard existing == nil else { return }
                switch newValue {
                case .tile: surface = .floor; coveragePerPack = 1.44; packUnit = "boxes"; wastePercent = 10; coats = 1
                case .flooring: surface = .floor; coveragePerPack = 2; packUnit = "packs"; wastePercent = 8; coats = 1
                case .paint: surface = .walls; coveragePerPack = 35; packUnit = "cans"; wastePercent = 5; coats = 2
                case .wallpaper: surface = .walls; coveragePerPack = 5; packUnit = "rolls"; wastePercent = 15; coats = 1
                case .baseboard: surface = .perimeter; coveragePerPack = 2.4; packUnit = "pieces"; wastePercent = 10; coats = 1
                case .other: surface = .manual; coveragePerPack = 1; packUnit = "units"; wastePercent = 0; coats = 1
                }
            }
        }
        .tint(AppTheme.slate)
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !packUnit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && rooms.contains(where: { $0.id == roomID })
        && [coveragePerPack, unitPrice, wastePercent, manualQuantity].allSatisfy(\.isFinite)
        && coveragePerPack > 0 && coveragePerPack <= 1_000_000
        && unitPrice >= 0 && unitPrice <= 1_000_000_000
        && wastePercent >= 0 && wastePercent <= 100 && manualQuantity >= 0 && manualQuantity <= 1_000_000_000
    }

    private var preview: MaterialEstimate? {
        guard isValid else { return nil }
        let draft = MaterialPlan(roomID: roomID, name: name, category: category,
                                 surface: surface, coveragePerPack: coveragePerPack,
                                 packUnit: packUnit, unitPrice: unitPrice,
                                 wastePercent: wastePercent, coats: coats,
                                 manualQuantity: manualQuantity,
                                 overridePacks: overrideEnabled ? overridePacks : nil)
        return EstimationService.material(draft, rooms: rooms, code: currencyCode)
    }

    private func quantityText(_ estimate: MaterialEstimate) -> String {
        "\(estimate.packs) \(packUnit.trimmingCharacters(in: .whitespacesAndNewlines))"
    }

    private func numberInput(_ label: String, value: Binding<Double>) -> some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading)) : AnyLayout(HStackLayout())
        return layout {
            Text(label)
            if !dynamicTypeSize.isAccessibilitySize { Spacer() }
            TextField("0", value: value, format: .number.precision(.fractionLength(0...2)))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(dynamicTypeSize.isAccessibilitySize ? .leading : .trailing)
                .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : 110)
                .accessibilityLabel(label)
        }
    }

    private func save() {
        var item = existing ?? MaterialPlan(roomID: roomID, name: name, category: category,
            surface: surface, coveragePerPack: coveragePerPack, packUnit: packUnit,
            unitPrice: unitPrice, wastePercent: wastePercent, coats: coats,
            manualQuantity: manualQuantity)
        item.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        item.roomID = roomID
        item.category = category
        item.surface = surface
        item.coveragePerPack = coveragePerPack
        item.packUnit = packUnit.trimmingCharacters(in: .whitespacesAndNewlines)
        item.unitPrice = unitPrice
        item.wastePercent = wastePercent
        item.coats = coats
        item.manualQuantity = manualQuantity
        item.overridePacks = overrideEnabled ? overridePacks : nil
        item.notes = notes
        if let error = onSave(item) {
            saveError = error
        } else {
            dismiss()
        }
    }
}
