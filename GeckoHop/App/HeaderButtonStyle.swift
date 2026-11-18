import SwiftUI

struct HeaderButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 44, minHeight: 44)
            .background(.quaternary.opacity(configuration.isPressed ? 1 : 0.45), in: RoundedRectangle(cornerRadius: 12))
            .contentShape(Rectangle())
            // 按压反馈保持触控区域，减少动态效果时只更新填色。
            .scaleEffect(!reduceMotion && configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: reduceMotion ? 0.12 : 0.17), value: configuration.isPressed)
    }
}
