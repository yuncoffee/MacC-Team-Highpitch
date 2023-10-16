import Foundation
import Security

enum KeyChainValue: String{
    case rzToken = "rzToken"
}
enum KeyChainError: Error{
    case convertDataErr
    case invalidItemFormat
    case unowned(OSStatus)
}
struct KeychainManager {
    private let service = Bundle.main.bundleIdentifier!
    
    func save(data: Encodable, forKey key: KeyChainValue) throws {
        let encoder = JSONEncoder()
        guard let saveData = try? encoder.encode(data) else{
            throw KeyChainError.convertDataErr
        }
//        guard let saveData = data.data(using: .utf8) else{
//            throw KeyChainError.convertDataErr
//        }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue,
            kSecValueData: saveData
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecDuplicateItem {
            // 이미 존재하는 경우, 업데이트합니다.
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: key.rawValue
            ]
            let attributesToUpdate: [String: Any] = [
                kSecValueData as String: saveData
            ]
            let updateStatus = SecItemUpdate(updateQuery as CFDictionary, attributesToUpdate as CFDictionary)
            if updateStatus != errSecSuccess {
                print("Failed to save data to Keychain")
            }
        }
    }

    func load(forKey key: KeyChainValue) throws -> Codable {
        let decoder = JSONDecoder()
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: true
        ]

        var data: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &data)

        guard status == errSecSuccess else{
            throw KeyChainError.unowned(status)
        }
        guard let data = data as? Data else{
            throw KeyChainError.invalidItemFormat
        }
        guard let data = try? decoder.decode(TokenData.self, from: data) else{
            throw KeyChainError.invalidItemFormat
        }
//        guard let data = String(data: data, encoding: .utf8) else{
//            throw KeyChainError.invalidItemFormat
//        }
        return data
    }

    func delete(forKey key: KeyChainValue) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status != errSecSuccess {
            print("Failed to delete data from Keychain")
        }
    }
}

