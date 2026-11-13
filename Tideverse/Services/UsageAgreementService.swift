import Foundation

enum UsageAgreementService {
    static let currentVersion = "eula-v1"
    static let versionKey = "tideverse.eulaVersion"
    static let acceptedAtKey = "tideverse.eulaAcceptedAt"

    static func isAccepted(in defaults: UserDefaults = .standard) -> Bool {
        defaults.string(forKey: versionKey) == currentVersion &&
        defaults.double(forKey: acceptedAtKey) > 0
    }

    static func accept(in defaults: UserDefaults = .standard) {
        defaults.set(currentVersion, forKey: versionKey)
        defaults.set(Date.now.timeIntervalSince1970, forKey: acceptedAtKey)
    }
}
