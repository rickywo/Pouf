import Combine
import Foundation

final class AppSettings: ObservableObject {
  var objectWillChange = ObservableObjectPublisher()

  @Published var ollamaURL: String {
    didSet { UserDefaults.standard.set(ollamaURL, forKey: "ollamaURL") }
  }

  @Published var ollamaModel: String {
    didSet { UserDefaults.standard.set(ollamaModel, forKey: "ollamaModel") }
  }

  @Published var systemPrompt: String {
    didSet { UserDefaults.standard.set(systemPrompt, forKey: "systemPrompt") }
  }

  init() {
    self.ollamaURL = UserDefaults.standard.string(forKey: "ollamaURL")
      ?? "http://localhost:11434"
    self.ollamaModel = UserDefaults.standard.string(forKey: "ollamaModel")
      ?? "llama3"
    self.systemPrompt = UserDefaults.standard.string(forKey: "systemPrompt")
      ?? "Fix grammar and make it sound professional. Only return the corrected text, nothing else."
  }
}
