import SwiftUI

struct OverviewBudgetCard: View {
    let total: Decimal
    let isUnavailable: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Estimated USD project budgets")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(isUnavailable ? "Unavailable" : EstimationService.money(total, code: "USD"))
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundStyle(AppTheme.deep)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(isUnavailable
                 ? "Check material coverage in your USD projects to calculate a total."
                 : "Totals from USD projects only. Other currencies appear in their respective projects.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
        .accessibilityElement(children: .combine)
    }
}
