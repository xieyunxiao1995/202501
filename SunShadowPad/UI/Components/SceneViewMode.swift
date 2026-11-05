import SwiftUI

enum SceneViewMode: String, CaseIterable, Identifiable, Sendable {
    case threeD = "3D"
    case plan = "Plan"

    var id: String { rawValue }
    var symbol: String {
        switch self {
        case .threeD: return "cube.transparent"
        case .plan: return "square.grid.2x2"
        }
    }
    var accessibilityLabel: String {
        switch self {
        case .threeD: return "3D view"
        case .plan: return "Plan view"
        }
    }
}

struct SceneViewModeToggle: View {
    @Binding var mode: SceneViewMode

    var body: some View {
        HStack(spacing: 2) {
            ForEach(SceneViewMode.allCases) { option in
                Button {
                    withAnimation(.snappy(duration: 0.2)) { mode = option }
                } label: {
                    Image(systemName: option.symbol)
                        .font(.system(size: 15, weight: .semibold))
                        .frame(width: 42, height: 34)
                        .foregroundStyle(mode == option ? AppTheme.navy : AppTheme.textMuted)
                        .background(mode == option ? AppTheme.yellow : Color.clear,
                                    in: RoundedRectangle(cornerRadius: 9))
                }
                .accessibilityLabel(option.accessibilityLabel)
                .accessibilityAddTraits(mode == option ? .isSelected : [])
            }
        }
        .padding(3)
        .background(AppTheme.navy.opacity(0.78), in: Capsule())
        .overlay(Capsule().strokeBorder(AppTheme.elevated.opacity(0.85), lineWidth: 1))
    }
}
