import SwiftUI

enum AppLanguage {
    static var current: String {
        resolve(preference: UserDefaults.standard.string(forKey: "language"),
                preferredLanguages: Locale.preferredLanguages,
                localeLanguage: Locale.current.languageCodeCompat)
    }

    static func resolve(preference: String?, preferredLanguages: [String], localeLanguage: String? = nil) -> String {
        if let preference, ["zh", "en"].contains(preference) { return preference }
        let primary = preferredLanguages.first ?? localeLanguage ?? "en"
        let subtag = primary.split(whereSeparator: { $0 == "-" || $0 == "_" }).first
        return subtag?.lowercased() == "zh" ? "zh" : "en"
    }
}

var isChinese: Bool { AppLanguage.current == "zh" }

func L(_ chinese: String, _ english: String) -> String {
    isChinese ? chinese : english
}

@propertyWrapper
struct AppLocalized: DynamicProperty {
    @Environment(\.locale) private var locale

    var wrappedValue: (String, String) -> String {
        let usesChinese = locale.languageCodeCompat == "zh"
        return { chinese, english in usesChinese ? chinese : english }
    }
}
