import Foundation

enum AppInfo {
    static let name = "SunShadowPad"
    // Neutral placeholders. Replace with the submitting party's real name and a monitored inbox before archiving.
    static let developer = "Independent Developer"
    static let supportEmail = "support@example.com"
    static let copyright = "© 2026 Independent Developer"

    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    static var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    static var supportAddress: URL? {
        guard hasConfiguredSupportEmail else { return nil }
        return URL(string: "mailto:\(supportEmail)")
    }

    static var hasConfiguredSupportEmail: Bool {
        !supportEmail.isEmpty && !supportEmail.hasSuffix("@example.com")
    }

    static var supportContactSentence: String {
        hasConfiguredSupportEmail
            ? "Questions can be sent to \(supportEmail)."
            : "Contact details are provided on the App Store product page."
    }
}
