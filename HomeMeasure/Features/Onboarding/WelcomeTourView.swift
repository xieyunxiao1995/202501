import SwiftUI

struct WelcomeTourView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pageIndex = 0

    private let pages = WelcomeTourPage.all
    private let onFinish: () -> Void

    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }

    private var isLastPage: Bool { pageIndex == pages.count - 1 }

    var body: some View {
        ZStack {
            LinearGradient(colors: [AppTheme.deep, AppTheme.slate],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                TabView(selection: $pageIndex) {
                    ForEach(pages) { page in
                        WelcomeTourPageView(page: page).tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                TourPageIndicator(pageCount: pages.count, selection: pageIndex)
                    .padding(.bottom, 18)
                primaryButton
            }
        }
        .tint(AppTheme.mist)
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: "house.fill")
                .font(.title3)
                .foregroundStyle(AppTheme.deep)
                .frame(width: 38, height: 38)
                .background(AppTheme.mist, in: RoundedRectangle(cornerRadius: 12))
                .accessibilityHidden(true)
            Text("HomeMeasure")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Spacer()
            Button("Skip", action: onFinish)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.mist)
                .frame(minWidth: 44, minHeight: 44)
                .accessibilityHint("Closes the introduction and opens the app")
        }
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var primaryButton: some View {
        Button(action: advance) {
            HStack(spacing: 8) {
                Text(isLastPage ? "Start Planning" : "Continue")
                Image(systemName: isLastPage ? "checkmark" : "arrow.right")
            }
            .font(.headline)
            .foregroundStyle(AppTheme.deep)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(AppTheme.mist, in: Capsule())
        }
        .accessibilityHint(isLastPage ? "Opens the app" : "Shows the next introduction page")
        .padding(.horizontal, 20)
        .padding(.bottom, 14)
    }

    private func advance() {
        guard !isLastPage else {
            onFinish()
            return
        }
        withAnimation(reduceMotion ? nil : .snappy) {
            pageIndex += 1
        }
    }
}
