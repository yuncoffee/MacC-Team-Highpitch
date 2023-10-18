import Foundation
import Security

enum KeyChainValue: String {
    case authToken = "authToken"
    case rzToken = "rzToken"
    
    func getReturnType() -> Codable.Type {
        switch self {
        case .authToken:
            return String.self as! Codable.Type
        case .rzToken:
            return TokenData.self as! Codable.Type
        }
    }
}
enum KeyChainError: Error {
    case convertDataErr
    case invalidItemFormat
    case unowned(OSStatus)
}

struct KeychainManager {
    private let service = Bundle.main.bundleIdentifier!
    
    func save(data: Encodable, forKey forkey: KeyChainValue) throws {
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
            kSecAttrAccount: forkey.rawValue,
            kSecValueData: saveData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecDuplicateItem {
            // 이미 존재하는 경우, 업데이트합니다.
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: forkey.rawValue
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
    
    func load(forKey forkey: KeyChainValue) throws -> Codable {
        let decoder = JSONDecoder()
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: forkey.rawValue,
            kSecReturnData: true
        ]
        
        var data: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &data)
        print(status)
        // MARK: 여기다!!!!!!!!여기다!!!!!!!!여기다!!!!!!!!여기다!!!!!!!!여기다!!!!!!!!
        guard status == errSecSuccess else {
            throw KeyChainError.unowned(status)
        }
        guard let data = data as? Data else {
            throw KeyChainError.invalidItemFormat
        }
        guard let data = try? decoder.decode(forkey.getReturnType(), from: data) else{
            throw KeyChainError.invalidItemFormat
        }
//        guard let data = String(data: data, encoding: .utf8) else{
//            throw KeyChainError.invalidItemFormat
//        }
        return data
    }
    
    func delete(forKey forkey: KeyChainValue) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: forkey.rawValue
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            print("Failed to delete data from Keychain")
        }
    }
}

