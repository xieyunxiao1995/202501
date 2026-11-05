import SwiftUI

struct TargetInspector: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var target: ObservationTarget
    let onDelete: () -> Void
    var body: some View {
        NavigationStack {
            Form {
                Section("Observation Target") {
                    TextField("Name", text: $target.name)
                    LabeledContent("Category", value: target.kind.rawValue)
                    TextField("Notes", text: $target.notes, axis: .vertical)
                }
                Section("Position · Metres") {
                    numericField("X", value: $target.x)
                    numericField("Y", value: $target.y)
                    if !target.isPoint {
                        numericField("Width", value: $target.width)
                        numericField("Depth", value: $target.depth)
                    }
                }
                Section("Direct Sunlight Target") {
                    HStack {
                        Text("Hours per day")
                        Spacer()
                        Text(target.targetHours.formatted(.number.precision(.fractionLength(1))))
                            .foregroundStyle(AppTheme.yellow)
                    }
                    Slider(value: $target.targetHours, in: 0...12, step: 0.5)
                    Text("This is your chosen threshold, not a plant-growth guarantee.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Section { Button("Delete Target", role: .destructive, action: onDelete) }
            }
            .scrollDismissesKeyboard(.interactively)
            .dismissKeyboardOnTap()
            .navigationTitle("Observation Area")
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
