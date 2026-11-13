import Foundation

/// This version describes the exact data-flow notice in AIConsentView. Bump it
/// whenever processors, transmitted categories or material terms change.
enum ConsentService {
    static let currentVersion = "deepseek-data-v2"
    static let versionKey = "tideverse.aiConsentVersion"
    static let acceptedAtKey = "tideverse.aiConsentAcceptedAt"
    static let revokedAtKey = "tideverse.aiConsentRevokedAt"
    static let enabledKey = "tideverse.cloudConsent"

    static func isGranted(in defaults: UserDefaults = .standard) -> Bool {
        defaults.bool(forKey: enabledKey) &&
        defaults.string(forKey: versionKey) == currentVersion &&
        defaults.double(forKey: acceptedAtKey) > 0
    }

    static func accept(in defaults: UserDefaults = .standard) {
        defaults.set(currentVersion, forKey: versionKey)
        defaults.set(Date.now.timeIntervalSince1970, forKey: acceptedAtKey)
        defaults.set(true, forKey: enabledKey)
    }

    static func revoke(in defaults: UserDefaults = .standard) {
        defaults.set(false, forKey: enabledKey)
        if defaults.double(forKey: acceptedAtKey) > 0 {
            defaults.set(Date.now.timeIntervalSince1970, forKey: revokedAtKey)
        }
    }

    static func clear(in defaults: UserDefaults = .standard) {
        for key in [enabledKey, versionKey, acceptedAtKey, revokedAtKey] {
            defaults.removeObject(forKey: key)
        }
    }
}
