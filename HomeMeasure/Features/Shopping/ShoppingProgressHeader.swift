import SwiftUI

struct ShoppingProgressHeader: View {
    let total: Int
    let purchased: Int
    @Binding var showPurchased: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Purchase progress")
                    .font(.headline)
                    .foregroundStyle(AppTheme.deep)
                Spacer()
                Text("\(purchased) of \(total)")
                    .foregroundStyle(AppTheme.slate)
            }
            ProgressView(value: Double(purchased), total: Double(max(1, total)))
                .tint(AppTheme.slate)
                .accessibilityLabel("Purchase progress")
                .accessibilityValue("\(purchased) of \(total) items purchased")
            Toggle("Show purchased items", isOn: $showPurchased)
                .font(.subheadline)
        }
        .padding(.vertical, 7)
    }
}
