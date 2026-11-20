import Foundation

enum LegacyPreferences {
    static func migrate(in defaults: UserDefaults) {
        copy("veil.language", to: "language", allowed: ["system", "zh", "en"], in: defaults)
        copy("veil.theme", to: "theme", allowed: ["system", "light", "dark"], in: defaults)
        copy("veil.node.last", to: "selectedNode", in: defaults)

        for key in ["smartRouting", "customRoutes", "veil.routing.mode", "veil.routing.custom"] {
            defaults.removeObject(forKey: key)
        }
        if let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            try? FileManager.default.removeItem(at: support.appendingPathComponent("GeckConnent/cn.vrs"))
        }
    }

    private static func copy(_ source: String, to destination: String,
                             allowed: Set<String>? = nil, in defaults: UserDefaults) {
        guard defaults.object(forKey: destination) == nil,
              let value = defaults.string(forKey: source), !value.isEmpty,
              allowed?.contains(value) != false else { return }
        defaults.set(value, forKey: destination)
    }
}
