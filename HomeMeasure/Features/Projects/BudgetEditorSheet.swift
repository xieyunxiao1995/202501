import SwiftUI
import SwiftData

struct BudgetEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let project: ProjectRecord

    @State private var currencyCode = "USD"
    @State private var taxPercent = 0.0
    @State private var shipping = 0.0
    @State private var notes = ""
    @State private var saveError: String?

    private let currencies = ["USD", "EUR", "GBP", "CAD", "AUD", "JPY", "SGD", "CHF", "CNY", "HKD"]

    private var isValid: Bool {
        taxPercent.isFinite && taxPercent >= 0 && taxPercent <= 100
        && shipping.isFinite && shipping >= 0 && shipping <= 1_000_000_000
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Cost settings") {
                    Picker("Currency", selection: $currencyCode) {
                        ForEach(currencies, id: \.self) { Text($0).tag($0) }
                    }
                    numberInput("Sales tax (%)", value: $taxPercent)
                    numberInput("Shipping / delivery", value: $shipping)
                }
                Section("Project notes") {
                    TextField("Notes for your report", text: $notes, axis: .vertical).lineLimit(3...6)
                }
                if !isValid {
                    Section {
                        Text("Enter a tax rate from 0 to 100 and shipping from 0 to 1,000,000,000.")
                            .foregroundStyle(.red)
                    }
                }
                Section {
                    Text("Prices are user-entered estimates and are not live supplier quotes. Changing currency does not convert existing prices.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Budget Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(!isValid)
                }
            }
            .alert("Unable to save budget", item: $saveError) { _ in
                Button("OK", role: .cancel) { }
            } message: { message in
                Text(message)
            }
            .onAppear {
                let doc = project.details
                currencyCode = doc.currencyCode
                taxPercent = doc.taxPercent
                shipping = doc.shipping
                notes = doc.notes
            }
        }
        .tint(AppTheme.slate)
    }

    private func numberInput(_ label: String, value: Binding<Double>) -> some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading)) : AnyLayout(HStackLayout())
        return layout {
            Text(label)
            if !dynamicTypeSize.isAccessibilitySize { Spacer() }
            TextField("0", value: value, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(dynamicTypeSize.isAccessibilitySize ? .leading : .trailing)
                .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : 120)
                .accessibilityLabel(label)
        }
    }

    private func save() {
        do {
            try project.requireAvailable(in: context)
            var doc = try project.readDetails()
            doc.currencyCode = currencyCode
            doc.taxPercent = taxPercent
            doc.shipping = shipping
            doc.notes = notes
            try project.update(doc)
            try context.save()
            dismiss()
        } catch {
            context.rollback()
            saveError = error.localizedDescription
        }
    }
}
