import SwiftUI

struct ProjectBudgetCard: View {
    let details: ProjectContent
    let budget: BudgetSummary
    let isTotalUnavailable: Bool
    let onEditBudget: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ESTIMATED TOTAL")
                .font(.caption.weight(.bold))
                .tracking(1.2)
                .foregroundStyle(AppTheme.mist)
            Text(isTotalUnavailable ? "Unavailable" : EstimationService.money(budget.total, code: details.currencyCode))
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            HStack(alignment: .center) {
                Text(isTotalUnavailable
                     ? "Check material coverage"
                     : "Materials \(EstimationService.money(budget.subtotal, code: details.currencyCode))")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.mist)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 8)
                Button(action: onEditBudget) {
                    Label("Budget options", systemImage: "slider.horizontal.3")
                        .font(.footnote.weight(.semibold))
                        .padding(.horizontal, 14)
                        .frame(minHeight: 44)
                        .background(AppTheme.mist, in: Capsule())
                        .foregroundStyle(AppTheme.deep)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [AppTheme.deep, AppTheme.slate],
                                   startPoint: .leading, endPoint: .trailing),
                    in: RoundedRectangle(cornerRadius: 22))
    }
}
