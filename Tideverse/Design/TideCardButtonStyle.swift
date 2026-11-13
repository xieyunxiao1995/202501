import SwiftUI

struct TideCardButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(TideMotion.press(reduced: reduceMotion, isPressed: configuration.isPressed), value: configuration.isPressed)
    }
}
