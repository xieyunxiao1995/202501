import Foundation
import Security

struct KeychainStore {
    let namespace: String

    func read<Value: Decodable>(_ key: String, as type: Value.Type) throws -> Value? {
        var query = attributes(key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecItemNotFound { return nil }
        try check(status)
        guard let data = result as? Data else { throw APIError(code: "storage") }
        return try JSONDecoder().decode(type, from: data)
    }

    func write<Value: Encodable>(_ key: String, value: Value?) throws {
        let query = attributes(key)
        guard let value else {
            let status = SecItemDelete(query as CFDictionary)
            if status != errSecItemNotFound { try check(status) }
            return
        }
        let payload = [kSecValueData as String: try JSONEncoder().encode(value)]
        let status = SecItemUpdate(query as CFDictionary, payload as CFDictionary)
        if status == errSecItemNotFound {
            var item = query.merging(payload) { _, new in new }
            item[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            try check(SecItemAdd(item as CFDictionary, nil))
        } else {
            try check(status)
        }
    }

    private func attributes(_ key: String) -> [String: Any] {
        [kSecClass as String: kSecClassGenericPassword, kSecAttrAccount as String: key,
         kSecAttrService as String: "com.GeckConnent.app.native." + namespace]
    }

    private func check(_ status: OSStatus) throws {
        guard status == errSecSuccess else { throw APIError(code: "storage") }
    }
}
