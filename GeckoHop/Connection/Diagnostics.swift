import Foundation

extension AppModel {
    static var appVersion: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        return "\(version) (\(build))"
    }
    static var coreVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "VeilCoreVersion") as? String ?? ""
    }

    func diagnostics() async -> [String: Any] {
        var result = await tunnel.diagnostics()
        result["v"] = 1
        result["time"] = Date.now.formatted(.iso8601)
        result["platform"] = "ios"
        result["app"] = Self.appVersion
        result["edition"] = "paid"
        result["core"] = Self.coreVersion
        result["os"] = ProcessInfo.processInfo.operatingSystemVersionString
        result["state"] = tunnel.status
        result["mode"] = "global"
        result["node"] = ["id": tunnel.nodeID, "name": tunnel.nodeName]
        if tunnel.active { result["traffic"] = ["up": tunnel.upload, "down": tunnel.download] }
        if let probe = tunnel.internetReachable { result["probe"] = probe ? "ok" : "failed" }
        return result
    }

    func diagnosticsText() async -> String {
        let result = await diagnostics()
        let data = (try? JSONSerialization.data(withJSONObject: result, options: [.prettyPrinted, .sortedKeys])) ?? Data()
        return "GeckConnent diagnostics\n" + String(decoding: data, as: UTF8.self)
    }
}
