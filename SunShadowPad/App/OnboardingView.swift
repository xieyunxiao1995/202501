import SwiftUI

struct OnboardingView: View {
    var onDone: () -> Void
    @State private var page = 0
    private let pages: [(String, String, String)] = [
        ("Plan With Sunlight", "Explore theoretical direct sunlight for the outdoor spaces you shape.", "sun.max.fill"),
        ("Build Your Scene", "Draw walls, buildings and trees at measured dimensions.", "square.on.square.dashed"),
        ("Watch Shadows Move", "Move through the day and reveal changing shade.", "clock.arrow.circlepath"),
        ("Discover Better Spots", "Compare layouts and export your local planning report.", "chart.xyaxis.line")
    ]
    var body: some View {
        ZStack {
            AppTheme.navy.ignoresSafeArea()
            VStack(spacing: 26) {
                Spacer()
                Image(systemName: pages[page].2)
                    .font(.system(size: 90, weight: .ultraLight))
                    .foregroundStyle(AppTheme.yellow)
                    .frame(height: 158)
                    .contentTransition(.symbolEffect(.replace))
                Text(pages[page].0).font(.largeTitle.bold()).multilineTextAlignment(.center)
                Text(pages[page].1).font(.title3).foregroundStyle(AppTheme.textMuted)
                    .multilineTextAlignment(.center).padding(.horizontal, 18)
                Spacer()
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { n in
                        Capsule().fill(n == page ? AppTheme.yellow : AppTheme.elevated)
                            .frame(width: n == page ? 28 : 8, height: 8)
                    }
                }
                Button(page == pages.count - 1 ? "Start Planning" : "Continue") {
                    if page == pages.count - 1 { onDone() }
                    else { withAnimation { page += 1 } }
                }
                .buttonStyle(.borderedProminent).tint(AppTheme.yellow)
                .foregroundStyle(.black).controlSize(.large).frame(maxWidth: .infinity)
                Button("Skip Introduction", action: onDone)
                    .font(.callout).foregroundStyle(AppTheme.textMuted)
                    .padding(.bottom, 20)
            }
            .padding(28)
        }
    }
}
