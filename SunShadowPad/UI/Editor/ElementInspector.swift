import SwiftUI

struct ElementInspector: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var element: SceneElement
    let onDuplicate: () -> Void
    let onDelete: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Object") {
                    TextField("Name", text: $element.name)
                    LabeledContent("Type", value: element.kind.rawValue)
                }
                Section("Position · Metres") {
                    numericField("X", value: $element.x)
                    numericField("Y", value: $element.y)
                    numericField("Width", value: $element.width)
                    numericField("Depth / Thickness", value: $element.depth)
                    numericField("Height", value: $element.height)
                    LabeledContent("Rotation") { TextField("Degrees", value: $element.rotation, format: .number)
                        .keyboardType(.decimalPad).multilineTextAlignment(.trailing) }
                }
                if element.kind == .tree {
                    Section("Tree Crown · Simplified Opaque Model") {
                        numericField("Crown Diameter", value: $element.crownDiameter)
                        numericField("Crown Base Height", value: $element.crownBaseHeight)
                        Text("A geometric opaque crown, not a foliage-transmission model.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
                Section("Layer") {
                    Toggle("Lock Position", isOn: $element.isLocked)
                    Toggle("Hide from Simulation", isOn: $element.isHidden)
                }
                Section {
                    Button("Duplicate Object", action: onDuplicate)
                    Button("Delete Object", role: .destructive, action: onDelete)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .dismissKeyboardOnTap()
            .navigationTitle("Edit Obstacle")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }

    private func numericField(_ title: String, value: Binding<Double>) -> some View {
        LabeledContent(title) {
            TextField(title, value: value, format: .number.precision(.fractionLength(0...2)))
                .keyboardType(.decimalPad).multilineTextAlignment(.trailing)
        }
    }
}
