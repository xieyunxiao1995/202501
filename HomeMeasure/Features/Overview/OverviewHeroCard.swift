import SwiftUI

struct OverviewHeroCard: View {
    let onStartProject: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("YOUR WORKSPACE")
                .font(.caption.weight(.bold))
                .tracking(1.2)
                .foregroundStyle(AppTheme.mist)
            Text("Everything you need for a more considered renovation.")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
            Button("Start a Project", systemImage: "plus.circle.fill", action: onStartProject)
                .font(.headline)
                .padding(.horizontal, 18)
                .padding(.vertical, 11)
                .background(AppTheme.mist, in: Capsule())
                .foregroundStyle(AppTheme.deep)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(LinearGradient(colors: [AppTheme.deep, AppTheme.slate],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 24))
    }
}
