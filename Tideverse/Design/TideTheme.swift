import SwiftUI
import UIKit

extension Color {
    init(hex: String) {
        let raw = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let value = Int(raw, radix: 16) ?? 0x368CFA
        self.init(red: Double((value >> 16) & 0xFF) / 255,
                  green: Double((value >> 8) & 0xFF) / 255,
                  blue: Double(value & 0xFF) / 255)
    }
}

/// Tideverse ships with a fixed dark-navy interface. Do not derive surfaces
/// from the system's light/dark appearance; the entire product stays dark.
enum TideColors {
    static let error = Color(hex: "FFB4B4")
    static let primary = Color(hex: "429EFF")
    static let bright = Color(hex: "79C8FF")
    static let deep = Color(hex: "F3F8FF")
    static let canvas = Color(hex: "071427")
    static let soft = Color(hex: "162C49")
    static let card = Color(hex: "11243C")
    static let ink = Color(hex: "F0F6FF")
    static let muted = Color(hex: "B2C6E0")
    static let border = Color(hex: "274568")
    static let highlight = Color(hex: "1A4779")
}

struct TideBackground: ViewModifier {
    func body(content: Content) -> some View {
        content.background {
            LinearGradient(
                colors: [Color(hex: "050F1F"), Color(hex: "0A1C33"), Color(hex: "071427")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}

extension View {
    func tideBackground() -> some View { modifier(TideBackground()) }
}

struct TidePrimaryButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
        }
        .buttonStyle(TidePrimaryButtonStyle())
    }
}

struct Eyebrow: View {
    let title: String
    var body: some View {
        Text(title.uppercased())
            .font(.caption2.weight(.bold))
            .tracking(1.4)
            .foregroundStyle(TideColors.bright)
    }
}

struct CharacterPortrait: View {
    let character: CharacterDefinition
    var body: some View {
        Image(character.portraitAsset)
            .resizable()
            .scaledToFit()
            .accessibilityLabel("Cartoon illustration of adult character \(character.name)")
    }
}
