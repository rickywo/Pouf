import Combine
import Foundation

final class AppSettings: ObservableObject {
  // MARK: - Active Provider

  @Published var activeProvider: AIProviderType {
    didSet {
      UserDefaults.standard.set(activeProvider.rawValue, forKey: "activeProvider")
    }
  }

  // MARK: - System Prompt

  @Published var systemPrompt: String {
    didSet {
      UserDefaults.standard.set(systemPrompt, forKey: "systemPrompt")
    }
  }

  // MARK: - Ollama Settings

  @Published var ollamaURL: String {
    didSet {
      UserDefaults.standard.set(ollamaURL, forKey: "ollamaURL")
    }
  }

  @Published var ollamaModel: String {
    didSet {
      UserDefaults.standard.set(ollamaModel, forKey: "ollamaModel")
    }
  }

  // MARK: - Gemini Settings

  @Published var geminiModel: String {
    didSet {
      UserDefaults.standard.set(geminiModel, forKey: "geminiModel")
    }
  }

  // MARK: - Grok Settings

  @Published var grokModel: String {
    didSet {
      UserDefaults.standard.set(grokModel, forKey: "grokModel")
    }
  }

  // MARK: - Initialization

  init() {
    let providerString = UserDefaults.standard.string(forKey: "activeProvider") ?? "ollama"
    self.activeProvider = AIProviderType(rawValue: providerString) ?? .ollama

    self.systemPrompt = UserDefaults.standard.string(forKey: "systemPrompt")
      ?? "Fix grammar and make it sound professional. Only return the corrected text, nothing else."

    self.ollamaURL = UserDefaults.standard.string(forKey: "ollamaURL")
      ?? "http://localhost:11434"
    self.ollamaModel = UserDefaults.standard.string(forKey: "ollamaModel")
      ?? "llama3"

    self.geminiModel = UserDefaults.standard.string(forKey: "geminiModel")
      ?? "gemini-2.0-flash"

    self.grokModel = UserDefaults.standard.string(forKey: "grokModel")
      ?? "grok-3-latest"
  }
}
