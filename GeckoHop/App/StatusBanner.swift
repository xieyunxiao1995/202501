import SwiftUI

struct StatusBanner: View {
    @AppLocalized private var L
    enum Tone {
        case information, warning, failure, success

        var symbol: String {
            switch self {
            case .information: "bell"
            case .warning: "exclamationmark.triangle"
            case .failure: "exclamationmark.octagon"
            case .success: "checkmark.seal"
            }
        }

        func title(using L: (String, String) -> String) -> String {
            switch self {
            case .information: L("服务通知", "Service notice")
            case .warning: L("需要留意", "Needs attention")
            case .failure: L("操作未完成", "Action incomplete")
            case .success: L("已完成", "Completed")
            }
        }

        var accent: Color {
            switch self {
            case .information: .blue
            case .warning: .orange
            case .failure: .red
            case .success: .green
            }
        }
    }

    let tone: Tone
    let message: String
    var title: String? = nil
    var dismiss: (() -> Void)? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Label(title ?? tone.title(using: L), systemImage: tone.symbol)
                .font(.subheadline.weight(.semibold))
                .labelStyle(BannerLabelStyle(accent: tone.accent))
            if !message.isEmpty {
                Text(message)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let dismiss {
                Button(L("收起提示", "Dismiss notice"), action: dismiss)
                    .font(.footnote.weight(.semibold))
                    .frame(minHeight: 44)
            }
        }
        .foregroundStyle(.primary)
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tone.accent.opacity(0.10), in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12).strokeBorder(tone.accent.opacity(0.22))
        }
        // 状态提示从当前位置淡入，减少动态效果时只保留透明度过渡。
        .transition(reduceMotion ? .opacity : .offset(y: 5).combined(with: .opacity))
    }

    private struct BannerLabelStyle: LabelStyle {
        let accent: Color

        func makeBody(configuration: Configuration) -> some View {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                configuration.icon
                    .foregroundStyle(accent)
                    .accessibilityHidden(true)
                configuration.title
            }
        }
    }
}
