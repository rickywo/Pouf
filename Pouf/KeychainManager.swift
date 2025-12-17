import Foundation
import Security

// MARK: - KeychainManager

final class KeychainManager {
  private let service = "com.pouf.aikeys"

  func saveAPIKey(_ key: String, for provider: AIProviderType) -> Bool {
    let account = provider.rawValue
    let data = key.data(using: .utf8)!

    // Delete existing key first
    deleteAPIKey(for: provider)

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecValueData as String: data
    ]

    let status = SecItemAdd(query as CFDictionary, nil)
    return status == errSecSuccess
  }

  func getAPIKey(for provider: AIProviderType) -> String? {
    let account = provider.rawValue

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]

    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)

    guard status == errSecSuccess,
          let data = result as? Data,
          let key = String(data: data, encoding: .utf8) else {
      return nil
    }

    return key
  }

  @discardableResult
  func deleteAPIKey(for provider: AIProviderType) -> Bool {
    let account = provider.rawValue

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account
    ]

    let status = SecItemDelete(query as CFDictionary)
    return status == errSecSuccess || status == errSecItemNotFound
  }

  func hasAPIKey(for provider: AIProviderType) -> Bool {
    getAPIKey(for: provider) != nil
  }
}
