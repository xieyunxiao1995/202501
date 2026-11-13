import Foundation

struct AppConfiguration {
    static let title = "Tideverse"
    static let subtitle = "AI Character Journeys"
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

    static var isAIConfigured: Bool { DeepSeekConfiguration.apiKey != nil }

}

extension AppConfiguration {
    static var studioName: String { configuredString("TIDEVERSE_STUDIO_NAME") ?? "Bluehour Storyworks" }
    static var publisherName: String? { configuredString("TIDEVERSE_PUBLISHER_NAME") }
    static var supportEmail: String? {
        guard let email = configuredString("TIDEVERSE_SUPPORT_EMAIL"),
              email.contains("@"), !email.contains(where: \.isWhitespace) else { return nil }
        return email
    }
    static var privacyPolicyURL: URL? { configuredHTTPSURL("TIDEVERSE_PRIVACY_URL") }
    static var supportURL: URL? { configuredHTTPSURL("TIDEVERSE_SUPPORT_URL") }
    static var legalEffectiveDate: String? { configuredString("TIDEVERSE_LEGAL_EFFECTIVE_DATE") }

    static func supportMailURL(subject: String, body: String) -> URL? {
        guard let supportEmail else { return nil }
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = supportEmail
        components.queryItems = [URLQueryItem(name: "subject", value: subject), URLQueryItem(name: "body", value: body)]
        return components.url
    }

    private static func configuredString(_ key: String) -> String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private static func configuredHTTPSURL(_ key: String) -> URL? {
        guard let value = configuredString(key), let url = URL(string: value),
              url.scheme == "https", url.host != nil else { return nil }
        return url
    }
}
