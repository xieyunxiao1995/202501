import SwiftUI

struct WelcomeTourPageView: View {
    let page: WelcomeTourPage

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Image(systemName: page.symbol)
                    .font(.largeTitle)
                    .foregroundStyle(AppTheme.deep)
                    .padding(26)
                    .background(AppTheme.mist, in: RoundedRectangle(cornerRadius: 28))
                    .accessibilityHidden(true)
                Text(page.eyebrow)
                    .font(.caption.weight(.bold))
                    .tracking(1.4)
                    .foregroundStyle(AppTheme.mist)
                Text(page.title)
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Text(page.message)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.86))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}
