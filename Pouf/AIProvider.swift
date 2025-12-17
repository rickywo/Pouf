import Foundation

// MARK: - AIProviderType

enum AIProviderType: String, CaseIterable, Codable {
  case ollama
  case gemini
  case grok

  var displayName: String {
    switch self {
    case .ollama: return "Ollama"
    case .gemini: return "Gemini"
    case .grok: return "Grok"
    }
  }

  var requiresAPIKey: Bool {
    switch self {
    case .ollama: return false
    case .gemini, .grok: return true
    }
  }
}

// MARK: - AIProviderError

enum AIProviderError: Error {
  case invalidURL
  case networkError(Error)
  case invalidResponse
  case decodingError(Error)
  case serverError(String)
  case missingAPIKey
  case unsupportedProvider
}

// MARK: - LocalizedError

extension AIProviderError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "Invalid API URL"
    case .networkError(let error):
      return "Network error: \(error.localizedDescription)"
    case .invalidResponse:
      return "Invalid response from AI provider"
    case .decodingError(let error):
      return "Failed to decode response: \(error.localizedDescription)"
    case .serverError(let message):
      return "Server error: \(message)"
    case .missingAPIKey:
      return "API key is required for this provider"
    case .unsupportedProvider:
      return "This AI provider is not supported"
    }
  }
}

// MARK: - RephraseProviding Protocol

protocol RephraseProviding {
  func rephrase(text: String) async throws -> String
}
