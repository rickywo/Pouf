import Foundation

// MARK: - Request/Response Models

struct GrokRequest: Codable {
  let model: String
  let messages: [GrokMessage]
  let stream: Bool
}

struct GrokMessage: Codable {
  let role: String
  let content: String
}

struct GrokResponse: Codable {
  let choices: [GrokChoice]?
  let error: GrokErrorResponse?
}

struct GrokChoice: Codable {
  let message: GrokMessage
}

struct GrokErrorResponse: Codable {
  let message: String
  let type: String?
}

// MARK: - GrokClient

final class GrokClient: RephraseProviding {
  private let apiKey: String
  private let model: String
  private let systemPrompt: String
  private let baseURL = "https://api.x.ai/v1/chat/completions"

  init(apiKey: String, model: String = "grok-3-latest", systemPrompt: String) {
    self.apiKey = apiKey
    self.model = model
    self.systemPrompt = systemPrompt
  }

  func rephrase(text: String) async throws -> String {
    guard !apiKey.isEmpty else {
      throw AIProviderError.missingAPIKey
    }

    guard let url = URL(string: baseURL) else {
      throw AIProviderError.invalidURL
    }

    let requestBody = GrokRequest(
      model: model,
      messages: [
        GrokMessage(role: "system", content: systemPrompt),
        GrokMessage(role: "user", content: "Text to improve:\n\(text)")
      ],
      stream: false
    )

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
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

    let grokResponse: GrokResponse
    do {
      grokResponse = try JSONDecoder().decode(GrokResponse.self, from: data)
    } catch {
      throw AIProviderError.decodingError(error)
    }

    if let error = grokResponse.error {
      throw AIProviderError.serverError(error.message)
    }

    guard httpResponse.statusCode == 200 else {
      let errorMessage = grokResponse.error?.message ?? "Unknown error (status: \(httpResponse.statusCode))"
      throw AIProviderError.serverError(errorMessage)
    }

    guard let choice = grokResponse.choices?.first else {
      throw AIProviderError.invalidResponse
    }

    return choice.message.content.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
