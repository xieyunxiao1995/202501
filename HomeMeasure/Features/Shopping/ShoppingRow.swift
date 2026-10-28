import SwiftUI

struct ShoppingRow: View {
    let line: MaterialEstimate
    let currencyCode: String
    let onToggle: () -> Void

    private var material: MaterialPlan { line.material }

    private var quantityText: String {
        line.quantityExceedsLimit ? "Quantity unavailable" : "\(line.packs) \(material.packUnit)"
    }

    private var costText: String {
        line.quantityExceedsLimit ? "Unavailable" : EstimationService.money(line.cost, code: currencyCode)
    }

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: material.purchased ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(material.purchased ? AppTheme.glacier : AppTheme.slate)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text(material.name)
                        .strikethrough(material.purchased)
                        .foregroundStyle(AppTheme.deep)
                        .font(.subheadline.weight(.semibold))
                    Text(line.quantityExceedsLimit ? "\(line.roomName) · Quantity unavailable" : "\(line.roomName) · \(quantityText)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if line.quantityExceedsLimit {
                        Text("Quantity exceeds supported limit; check coverage.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                Spacer()
                Text(costText)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(AppTheme.deep)
            }
            .padding(.vertical, 4)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(material.purchased ? "Mark not purchased" : "Mark purchased"): \(material.name)")
        .accessibilityValue(line.quantityExceedsLimit
                            ? "\(line.roomName), quantity and cost unavailable"
                            : "\(line.roomName), \(quantityText), \(costText)")
    }
}
