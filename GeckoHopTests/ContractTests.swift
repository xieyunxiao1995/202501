import CryptoKit
import XCTest
@testable import GeckConnent

final class ContractTests: XCTestCase {
    @MainActor
    func testAccountRequestsRenewAndClearStoredSession() async throws {
        let api = client()
        let model = AppModel(api: api)
        let vault = KeychainStore(namespace: api.base)
        defer { try? vault.write("session", value: Optional<Session>.none) }

        try await model.authenticate(path: "/user/register", body: [
            "email": "test@example.com", "password": "test-pass", "code": "314159", "invite_code": "ABCDEFGH"
        ])
        XCTAssertEqual(model.session?.accessToken, "registration")
        XCTAssertEqual(try vault.read("session", as: Session.self)?.accessToken, "registration")

        try await model.authenticate(path: "/user/login", body: ["email": "test@example.com", "password": "test-pass"])
        XCTAssertEqual(model.session?.accessToken, "login")
        await model.refreshSession()
        XCTAssertEqual(model.session?.accessToken, "renewed")
        XCTAssertEqual(try vault.read("session", as: Session.self)?.accessToken, "renewed")
        do {
            _ = try await model.authorized("/user/invite")
            XCTFail("Expected a revoked session")
        } catch let error as APIError { XCTAssertEqual(error.status, 401) }
        XCTAssertNil(model.session)
        XCTAssertNil(try vault.read("session", as: Session.self))
    }

    @MainActor
    func testNodesAndPendingRetryHeader() async throws {
        let api = client()
        let nodes = try await Node.decode(api.call("/nodes"))
        XCTAssertEqual(nodes.map(\.id), ["tokyo", "osaka"])
        let config = try await api.call("/v2/user/connection-config", method: "POST",
            body: ["node_id": "tokyo", "device_key": "public-key"], authorization: "Bearer renewed")
        XCTAssertEqual(config["status"] as? String, "pending")
        XCTAssertEqual(config["retry_after"] as? Int, 2)
    }

    @MainActor
    func testConnectionGrantKeepsDeviceKeyAcrossPendingRetry() async throws {
        let api = client(scenario: "pending")
        let model = AppModel(api: api)
        defer { try? KeychainStore(namespace: api.base).write("session", value: Optional<Session>.none) }
        try await signIn(model)
        await model.refreshNodes()
        let node = try XCTUnwrap(model.nodes.first)
        let config = try await model.connectionConfiguration(for: node)

        let encodedSecret = try XCTUnwrap(config["deviceSecret"] as? String)
        let rawSecret = try XCTUnwrap(Data(base64Encoded: encodedSecret.replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/") + "="))
        let secret = try Curve25519.KeyAgreement.PrivateKey(rawRepresentation: rawSecret)
        let encodedPublic = secret.publicKey.rawRepresentation.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        XCTAssertEqual(config["sealed"] as? String, "s2." + encodedPublic)
        XCTAssertEqual(config["accountId"] as? String, model.session?.user.uuid)
        XCTAssertEqual(config["nodeId"] as? String, node.id)
        XCTAssertEqual(config["apiToken"] as? String, "login")
        XCTAssertEqual(config["apiBase"] as? String, api.base)
        XCTAssertEqual(config["configPath"] as? String, "/v2/user/connection-config")
        XCTAssertEqual(config["statusPath"] as? String, "/user/connection-status")
    }

    @MainActor
    func testExpiredOrForeignConnectionGrantIsRejected() async throws {
        for (scenario, expectedCode) in [("expired", "device_clock_ahead"), ("foreign", "response")] {
            let api = client(scenario: scenario)
            let model = AppModel(api: api)
            defer { try? KeychainStore(namespace: api.base).write("session", value: Optional<Session>.none) }
            try await signIn(model)
            await model.refreshNodes()
            let node = try XCTUnwrap(model.nodes.first)
            do {
                _ = try await model.connectionConfiguration(for: node)
                XCTFail("An unusable grant must not be passed to NetworkExtension")
            } catch let error as APIError {
                XCTAssertEqual(error.code, expectedCode)
            }
        }
    }

    @MainActor
    func testPuzzleTicketUnlocksResetCodeAndPasswordReset() async throws {
        let api = client()
        let email = "test@example.com"
        let puzzle = try await api.loadPuzzle(email: email, purpose: "reset")
        XCTAssertEqual(puzzle.width - puzzle.pieceWidth, 200)
        do {
            _ = try await api.verifyPuzzle(puzzle, position: 201)
            XCTFail("An out-of-range puzzle coordinate must be rejected")
        } catch let error as APIError {
            XCTAssertEqual(error.code, "captcha_position")
        }

        let ticket = try await api.verifyPuzzle(puzzle, position: 62.75)
        let wait = try await api.sendAccountCode(email: email, ticket: ticket, mode: .reset)
        XCTAssertEqual(wait, 45)
        try await api.resetPassword(email: email, code: "314159", password: "new-test-password")
    }

    @MainActor
    func testRegistrationUsesPuzzleTicketAndEmailCode() async throws {
        let api = client()
        let model = AppModel(api: api)
        defer { try? KeychainStore(namespace: api.base).write("session", value: Optional<Session>.none) }
        let email = "test@example.com"
        let puzzle = try await api.loadPuzzle(email: email, purpose: "register")
        let ticket = try await api.verifyPuzzle(puzzle, position: 63)
        let wait = try await api.sendAccountCode(email: email, ticket: ticket, mode: .register)
        XCTAssertEqual(wait, 60)
        try await model.authenticate(path: "/user/register", body: [
            "email": email, "password": "test-pass", "code": "314159", "invite_code": "ABCDEFGH"
        ])
        XCTAssertEqual(model.session?.accessToken, "registration")
    }

    @MainActor
    func testSupportUsesSeparateVisitorAndAccountIdentities() async throws {
        let api = client()
        let model = AppModel(api: api)
        let vault = KeychainStore(namespace: api.base)
        defer {
            try? vault.write("visitor", value: Optional<String>.none)
            try? vault.write("session", value: Optional<Session>.none)
        }
        try await model.createVisitor("visitor-ticket")
        let visitor = try XCTUnwrap(model.supportIdentity)
        XCTAssertEqual(visitor, .visitor("test-visitor"))
        await model.refreshSupportUnread()
        XCTAssertEqual(model.supportUnread, 2)
        try await signIn(model)
        await model.refreshSupportUnread()
        XCTAssertEqual(model.supportUnread, 4)
        do {
            _ = try await model.support("/conversation", identity: visitor)
            XCTFail("A stale visitor operation must not use the signed-in account")
        } catch is CancellationError {}
        await model.signOut()
        do {
            _ = try await model.support("/revoked-test", identity: visitor)
            XCTFail("A revoked visitor must be removed")
        } catch let error as APIError {
            XCTAssertEqual(error.status, 401)
        }
        XCTAssertNil(model.visitorToken)
    }

    func testLegacyPreferencesKeepRoutingAndRespectNewChoices() throws {
        let suite = UUID().uuidString
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set("dark", forKey: "veil.theme")
        defaults.set("zh", forKey: "veil.language")
        defaults.set("osaka", forKey: "veil.node.last")
        defaults.set("rule", forKey: "veil.routing.mode")
        defaults.set(["direct:*.example.com", "proxy:example.com", "proxy:example.net",
                      "invalid:ignored.test", "proxy:bad..test"], forKey: "veil.routing.custom")

        LegacyPreferences.migrate(in: defaults)

        XCTAssertEqual(defaults.string(forKey: "theme"), "dark")
        XCTAssertEqual(defaults.string(forKey: "language"), "zh")
        XCTAssertEqual(defaults.string(forKey: "selectedNode"), "osaka")
        XCTAssertTrue(defaults.bool(forKey: "smartRouting"))
        XCTAssertEqual(defaults.array(forKey: "customRoutes") as? [[String: String]], [
            ["domain": "example.com", "out": "direct"], ["domain": "example.net", "out": "proxy"]
        ])

        defaults.set("light", forKey: "theme")
        defaults.set(false, forKey: "smartRouting")
        defaults.set([], forKey: "customRoutes")
        LegacyPreferences.migrate(in: defaults)

        XCTAssertEqual(defaults.string(forKey: "theme"), "light")
        XCTAssertFalse(defaults.bool(forKey: "smartRouting"))
        XCTAssertEqual(defaults.array(forKey: "customRoutes")?.count, 0)
    }

    @MainActor
    private func signIn(_ model: AppModel) async throws {
        try await model.authenticate(path: "/user/login", body: ["email": "test@example.com", "password": "test-pass"])
    }

    func testLanguageFollowsPrimaryPhoneLanguageWithEnglishFallback() {
        XCTAssertEqual(AppLanguage.resolve(preference: "system", preferredLanguages: ["zh-Hans-CN", "en"]), "zh")
        XCTAssertEqual(AppLanguage.resolve(preference: "system", preferredLanguages: ["zh-Hant-TW"]), "zh")
        XCTAssertEqual(AppLanguage.resolve(preference: "system", preferredLanguages: ["fr-FR", "zh"]), "en")
        XCTAssertEqual(AppLanguage.resolve(preference: "system", preferredLanguages: ["en-CN"]), "en")
        XCTAssertEqual(AppLanguage.resolve(preference: nil, preferredLanguages: []), "en")
        XCTAssertEqual(AppLanguage.resolve(preference: "en", preferredLanguages: ["zh-Hans"]), "en")
        XCTAssertEqual(AppLanguage.resolve(preference: "zh", preferredLanguages: ["en"]), "zh")
    }

    @MainActor
    private func client(scenario: String = "standard") -> APIClient {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [ContractURLProtocol.self]
        return APIClient(base: "https://" + scenario + "." + UUID().uuidString.lowercased() + ".example.invalid",
                         transport: URLSession(configuration: config))
    }
}
