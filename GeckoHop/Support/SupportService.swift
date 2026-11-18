import Foundation
import ImageIO
import UniformTypeIdentifiers

extension AppModel {
    static var supportVersion: String? {
        supportVersion(
            version: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            build: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        )
    }

    static func supportVersion(version: String?, build: String?) -> String? {
        guard let version, !version.isEmpty, let build, !build.isEmpty else { return nil }
        let value = "\(version)+\(build)"
        return value.range(of: #"^[0-9A-Za-z.+_-]{1,32}$"#, options: .regularExpression) == nil ? nil : value
    }

    private var visitorStore: KeychainStore { KeychainStore(namespace: api.base) }
    var visitorToken: String? { try? visitorStore.read("visitor", as: String.self) }

    var supportIdentity: SupportIdentity? {
        if let session { return .account(session.user.uuid) }
        return visitorToken.map(SupportIdentity.visitor)
    }

    func createVisitor(_ ticket: String) async throws {
        var body = ["captcha_token": ticket, "source": "ios"]
        body["app_version"] = Self.supportVersion
        let value = try await api.call("/support/visitor", method: "POST", body: body)
        guard let token = value["visitor_token"] as? String, !token.isEmpty else { throw APIError(code: "response") }
        try visitorStore.write("visitor", value: token)
    }

    func support(_ path: String, method: String = "GET", body: [String: Any]? = nil,
                 identity required: SupportIdentity? = nil) async throws -> [String: Any] {
        guard let identity = supportIdentity else { throw APIError(status: 401, code: "invalid_token") }
        if let required, required != identity { throw CancellationError() }
        switch identity {
        case .account:
            return try await authorized("/support" + path, method: method, body: body)
        case .visitor(let token):
            do {
                let reply = try await api.call("/support" + path, method: method, body: body,
                                               authorization: "Visitor " + token)
                guard identity == supportIdentity else { throw CancellationError() }
                return reply
            } catch let error as APIError where error.status == 401 || error.status == 410 {
                if token == visitorToken { try visitorStore.write("visitor", value: Optional<String>.none) }
                throw error
            }
        }
    }

    func refreshSupportUnread() async {
        guard let identity = supportIdentity else { return }
        if let response = try? await support("/conversation", identity: identity), identity == supportIdentity {
            supportUnread = response["unread"] as? Int ?? 0
        }
    }

    func uploadImage(_ original: Data, identity: SupportIdentity) async throws -> [String: Any] {
        guard let source = CGImageSourceCreateWithData(original as CFData, nil),
              let image = CGImageSourceCreateThumbnailAtIndex(source, 0, [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: 1600
              ] as CFDictionary) else { throw APIError(code: "invalid_image") }
        let data = NSMutableData()
        guard let encoder = CGImageDestinationCreateWithData(data, UTType.jpeg.identifier as CFString, 1, nil) else {
            throw APIError(code: "invalid_image")
        }
        CGImageDestinationAddImage(encoder, image, [kCGImageDestinationLossyCompressionQuality: 0.8] as CFDictionary)
        guard CGImageDestinationFinalize(encoder), (1...(5 * 1024 * 1024)).contains(data.length) else {
            throw APIError(code: "invalid_image")
        }
        let upload = try await support("/uploads", method: "POST", body: ["content_type": "image/jpeg", "size": data.length], identity: identity)
        guard let key = upload["image_key"] as? String, let address = upload["put_url"] as? String,
              let url = URL(string: address), url.scheme == "https", url.host != nil,
              let headers = upload["headers"] as? [String: String] else { throw APIError(code: "response") }
        var request = URLRequest(url: url, timeoutInterval: 30)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        let (_, response) = try await api.transport.upload(for: request, from: data as Data)
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
            throw APIError(code: "image_upload")
        }
        guard identity == supportIdentity else { throw CancellationError() }
        return ["image_key": key, "width": image.width, "height": image.height]
    }
}
