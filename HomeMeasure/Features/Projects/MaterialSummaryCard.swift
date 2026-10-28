import SwiftUI

struct MaterialSummaryCard: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let estimate: MaterialEstimate
    let currencyCode: String
    let onEdit: () -> Void
    let onTogglePurchased: () -> Void
    let onDelete: () -> Void

    private var material: MaterialPlan { estimate.material }

    private var quantityText: String {
        estimate.quantityExceedsLimit ? "Quantity unavailable" : "\(estimate.packs) \(material.packUnit)"
    }

    private var costText: String {
        estimate.quantityExceedsLimit ? "Unavailable" : EstimationService.money(estimate.cost, code: currencyCode)
    }

    var body: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 6))
            : AnyLayout(HStackLayout(spacing: 12))

        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: material.category.symbol)
                    .foregroundStyle(AppTheme.slate)
                    .frame(width: 34, height: 34)
                    .background(AppTheme.mist, in: RoundedRectangle(cornerRadius: 10))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(material.name)
                        .font(.headline)
                        .foregroundStyle(AppTheme.deep)
                    Text("\(estimate.roomName) · \(material.category.rawValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 8)
                optionsMenu
            }
            layout {
                HStack(spacing: 8) {
                    Text(quantityText)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(AppTheme.deep)
                    if material.purchased {
                        Label("Purchased", systemImage: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(AppTheme.slate)
                    }
                }
                Spacer(minLength: 0)
                Text(costText)
                    .font(.headline)
                    .foregroundStyle(AppTheme.deep)
            }
            Text("\(EstimationService.money(EstimationService.decimal(material.unitPrice), code: currencyCode)) per package · \(material.overridePacks == nil ? "Calculated quantity" : "Package count overridden")")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            if estimate.quantityExceedsLimit {
                Text("Calculated quantity exceeds the supported limit. Check coverage or set an override.")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Text("Required: \(EstimationService.measure(estimate.requiredQuantity, unit: material.surface.unit)) · \(material.wastePercent.formatted())% waste")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 19))
    }

    private var optionsMenu: some View {
        Menu {
            Button("Edit", systemImage: "pencil", action: onEdit)
            Button(material.purchased ? "Mark Not Purchased" : "Mark Purchased",
                   systemImage: material.purchased ? "arrow.uturn.backward.circle" : "checkmark.circle",
                   action: onTogglePurchased)
            Button("Delete", systemImage: "trash", role: .destructive, action: onDelete)
        } label: {
            Label("Material options", systemImage: "ellipsis.circle")
        }
        .labelStyle(.iconOnly)
        .accessibilityLabel("Options for \(material.name)")
    }
}
