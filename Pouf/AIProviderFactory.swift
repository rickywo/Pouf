import Foundation

// MARK: - AIProviderFactory

final class AIProviderFactory {
  private let settings: AppSettings
  private let keychainManager: KeychainManager

  init(settings: AppSettings, keychainManager: KeychainManager = KeychainManager()) {
    self.settings = settings
    self.keychainManager = keychainManager
  }

  func makeProvider() throws -> RephraseProviding {
    switch settings.activeProvider {
    case .ollama:
      return OllamaClient(
        baseURL: settings.ollamaURL,
        model: settings.ollamaModel,
        systemPrompt: settings.systemPrompt
      )

    case .gemini:
      guard let apiKey = keychainManager.getAPIKey(for: .gemini), !apiKey.isEmpty else {
        throw AIProviderError.missingAPIKey
      }
      return GeminiClient(
        apiKey: apiKey,
        model: settings.geminiModel,
        systemPrompt: settings.systemPrompt
      )

    case .grok:
      guard let apiKey = keychainManager.getAPIKey(for: .grok), !apiKey.isEmpty else {
        throw AIProviderError.missingAPIKey
      }
      return GrokClient(
        apiKey: apiKey,
        model: settings.grokModel,
        systemPrompt: settings.systemPrompt
      )
    }
  }
}
