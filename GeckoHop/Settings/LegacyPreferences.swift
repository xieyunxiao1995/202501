import Foundation

enum LegacyPreferences {
    static func migrate(in defaults: UserDefaults) {
        copy("veil.language", to: "language", allowed: ["system", "zh", "en"], in: defaults)
        copy("veil.theme", to: "theme", allowed: ["system", "light", "dark"], in: defaults)
        copy("veil.node.last", to: "selectedNode", in: defaults)

        if defaults.object(forKey: "smartRouting") == nil,
           let mode = defaults.string(forKey: "veil.routing.mode"),
           ["global", "rule"].contains(mode) {
            defaults.set(mode == "rule", forKey: "smartRouting")
        }

        if defaults.object(forKey: "customRoutes") == nil,
           let legacy = defaults.stringArray(forKey: "veil.routing.custom") {
            var seen = Set<String>()
            let routes = legacy.compactMap { item -> [String: String]? in
                let fields = item.split(separator: ":", maxSplits: 1)
                guard fields.count == 2, ["direct", "proxy"].contains(fields[0]),
                      let domain = RoutingRules.domain(String(fields[1])),
                      seen.insert(domain).inserted else { return nil }
                return ["domain": domain, "out": String(fields[0])]
            }
            defaults.set(Array(routes.prefix(200)), forKey: "customRoutes")
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
