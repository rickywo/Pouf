import Foundation

// MARK: - Request/Response Models

struct OllamaGenerateRequest: Codable {
  let model: String
  let prompt: String
  let stream: Bool
}

struct OllamaGenerateResponse: Codable {
  let response: String
}

// MARK: - OllamaClient

final class OllamaClient: RephraseProviding {
  private let baseURL: String
  private let model: String
  private let systemPrompt: String

  init(baseURL: String, model: String, systemPrompt: String) {
    self.baseURL = baseURL
    self.model = model
    self.systemPrompt = systemPrompt
  }

  func rephrase(text: String) async throws -> String {
    guard let url = URL(string: "\(baseURL)/api/generate") else {
      throw AIProviderError.invalidURL
    }

    let fullPrompt = "\(systemPrompt)\n\nText to improve:\n\(text)"
    let requestBody = OllamaGenerateRequest(
      model: model,
      prompt: fullPrompt,
      stream: false
    )

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.timeoutInterval = 30

    do {
      request.httpBody = try JSONEncoder().encode(requestBody)
    } catch {
      throw AIProviderError.decodingError(error)
    }

    let data: Data
    let response: URLResponse

    do {
      (data, response) = try await URLSession.shared.data(for: request)
    } catch {
      throw AIProviderError.networkError(error)
    }

    guard let httpResponse = response as? HTTPURLResponse else {
      throw AIProviderError.invalidResponse
    }

    guard httpResponse.statusCode == 200 else {
      let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
      throw AIProviderError.serverError(errorMessage)
    }

    do {
      let ollamaResponse = try JSONDecoder().decode(OllamaGenerateResponse.self, from: data)
      return ollamaResponse.response.trimmingCharacters(in: .whitespacesAndNewlines)
    } catch {
      throw AIProviderError.decodingError(error)
    }
  }
}
