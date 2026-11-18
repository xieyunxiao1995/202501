import Foundation

enum RoutingRules {
    static let builtIn: Int64 = 202611070230
    static let file = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("GeckConnent/cn.vrs")
    static let download = URL(string: "https://github.com/zizhu880/veil-core-releases/releases/download/rules/cn.vrs")!

    static var version: Int64 {
        max(builtIn, (try? Data(contentsOf: file)).flatMap(RuleFile.version) ?? 0)
    }

    static func domain(_ input: String) -> String? {
        var domain = input.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if let scheme = domain.range(of: "://") { domain = String(domain[scheme.upperBound...]) }
        if let delimiter = domain.firstIndex(where: { "/:".contains($0) }) { domain = String(domain[..<delimiter]) }
        while domain.hasPrefix("*.") || domain.hasPrefix(".") {
            domain.removeFirst(domain.hasPrefix("*.") ? 2 : 1)
        }
        if domain.hasSuffix(".") { domain.removeLast() }
        guard domain.count <= 253, !domain.contains(".."),
              domain.range(of: #"^[a-z0-9_.-]+$"#, options: .regularExpression) != nil else { return nil }
        return domain
    }

    static func update() async throws -> Int64 {
        let (fileURL, response) = try await URLSession.shared.download(from: download)
        guard (response as? HTTPURLResponse)?.statusCode == 200,
              let length = try fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize,
              length <= RuleFile.maxSize else { throw APIError(code: "rules_download") }
        let data = try Data(contentsOf: fileURL)
        guard let incoming = RuleFile.version(data), incoming > 0 else { throw APIError(code: "rules_invalid") }
        if incoming > version {
            try FileManager.default.createDirectory(at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: file, options: .atomic)
        }
        return version
    }
}
