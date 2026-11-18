import Combine
import Foundation

@MainActor
final class ServiceInfo: ObservableObject {
    @Published private(set) var notice: [String: Any]?
    @Published private(set) var upgrade: [String: Any]?
    @Published private(set) var website = URL(string: "https://GeckConnent.com")!
    @Published private(set) var email = ""
    private var lastVersionAttempt: Date?
    private var lastVersionSuccess: Date?
    private var lastNotices: Date?
    private var noticeRevision = 0
    private var loadedBase: String?
    private var versionInFlight = false

    var requiresUpdate: Bool { upgrade?["is_force_update"] as? Bool == true }
    var updateURL: URL? { secureURL(upgrade?["url"]) }
    var noticeID: String? {
        guard let notice, let id = notice["id"], let date = notice["updated_at"] else { return nil }
        return "\(id):\(date)"
    }

    func refreshVersion(api: APIClient) async {
        guard !versionInFlight else { return }
        versionInFlight = true
        defer { versionInFlight = false }
        let cacheKey = "version." + api.base
        if loadedBase != api.base {
            loadedBase = api.base
            if let saved = UserDefaults.standard.dictionary(forKey: cacheKey),
               let payload = saved["payload"] as? [String: Any] {
                apply(payload)
                lastVersionSuccess = saved["date"] as? Date
            }
        }
        let now = Date()
        if let lastVersionSuccess, now.timeIntervalSince(lastVersionSuccess) < 3600 { return }
        if let lastVersionAttempt, now.timeIntervalSince(lastVersionAttempt) < 60 { return }
        lastVersionAttempt = now
        do {
            let payload = try await api.call("/app/version?platform=ios")
            guard payload["version"] is String, payload["build_number"] is Int else { return }
            lastVersionSuccess = now
            apply(payload)
            let cleaned = payload.filter { !($0.value is NSNull) }
            UserDefaults.standard.set(["payload": cleaned, "date": now], forKey: cacheKey)
        } catch {}
    }

    func refreshNotices(api: APIClient, force: Bool = false) async {
        if !force, let lastNotices, Date().timeIntervalSince(lastNotices) < 1800 { return }
        let lang = isChinese ? "zh" : "en"
        noticeRevision += 1
        let revision = noticeRevision
        do {
            let response = try await api.call("/app/notices?platform=ios&edition=paid&lang=" + lang)
            guard revision == noticeRevision, !Task.isCancelled else { return }
            let notices = response["notices"] as? [[String: Any]] ?? []
            let dismissed = UserDefaults.standard.stringArray(forKey: "notices.dismissed") ?? []
            notice = notices.first { item in
                guard let id = item["id"], let date = item["updated_at"] else { return false }
                return !dismissed.contains("\(id):\(date)")
            }
            lastNotices = Date()
        } catch {}
    }

    func dismiss(api: APIClient) async {
        if let noticeID {
            let dismissed = UserDefaults.standard.stringArray(forKey: "notices.dismissed") ?? []
            UserDefaults.standard.set(Array((dismissed + [noticeID]).suffix(200)), forKey: "notices.dismissed")
        }
        notice = nil
        await refreshNotices(api: api, force: true)
    }

    private func apply(_ payload: [String: Any]) {
        if let url = secureURL(payload["website"]) { website = url }
        email = payload["support_email"] as? String ?? ""
        guard let remote = payload["version"] as? String, let build = payload["build_number"] as? Int else { return }
        let local = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
        let localBuild = Int(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "") ?? 0
        let ordering = compare(remote, local)
        upgrade = ordering == .orderedDescending || (ordering == .orderedSame && build > localBuild) ? payload : nil
    }

    private func secureURL(_ value: Any?) -> URL? {
        guard let value = value as? String, let url = URL(string: value), url.scheme == "https", url.host != nil else { return nil }
        return url
    }

    private func compare(_ left: String, _ right: String) -> ComparisonResult {
        let l = left.split(separator: ".").map { Int($0) ?? 0 }
        let r = right.split(separator: ".").map { Int($0) ?? 0 }
        for i in 0..<max(l.count, r.count) {
            let a = i < l.count ? l[i] : 0
            let b = i < r.count ? r[i] : 0
            if a != b { return a < b ? .orderedAscending : .orderedDescending }
        }
        return .orderedSame
    }
}
