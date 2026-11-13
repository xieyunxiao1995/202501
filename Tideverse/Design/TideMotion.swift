import SwiftUI

/// ui-motion 的原生映射：短反馈、250ms 消息落位、350ms 面板切换。
enum TideMotion {
    static func press(reduced: Bool, isPressed: Bool) -> Animation? {
        guard !reduced else { return nil }
        return isPressed
            ? .timingCurve(0.4, 0, 0.2, 1, duration: 0.06)
            : .timingCurve(0.34, 1.56, 0.64, 1, duration: 0.15)
    }

    static func feedback(reduced: Bool) -> Animation? {
        reduced ? nil : .timingCurve(0, 0, 0.2, 1, duration: 0.2)
    }

    static func arrival(reduced: Bool) -> Animation? {
        reduced ? nil : .timingCurve(0, 0, 0.2, 1, duration: 0.25)
    }

    static func panel(reduced: Bool) -> Animation? {
        reduced ? nil : .timingCurve(0, 0, 0.2, 1, duration: 0.35)
    }

    static func navigation(reduced: Bool) -> Animation? {
        reduced ? nil : .timingCurve(0, 0, 0.2, 1, duration: 0.45)
    }

    static func message(reduced: Bool, isUser: Bool) -> AnyTransition {
        guard !reduced else { return .identity }
        return .asymmetric(
            insertion: .offset(x: isUser ? 8 : -8, y: 10).combined(with: .opacity),
            removal: .opacity
        )
    }

    static func row(reduced: Bool) -> AnyTransition {
        reduced ? .identity : .opacity.combined(with: .scale(scale: 0.98))
    }
}
