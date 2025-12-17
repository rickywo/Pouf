import Foundation

// MARK: - Request/Response Models

struct GeminiRequest: Codable {
  let contents: [GeminiContent]
  let systemInstruction: GeminiContent?

  enum CodingKeys: String, CodingKey {
    case contents
    case systemInstruction = "system_instruction"
  }
}

struct GeminiContent: Codable {
  let parts: [GeminiPart]
}

struct GeminiPart: Codable {
  let text: String
}

struct GeminiResponse: Codable {
  let candidates: [GeminiCandidate]?
  let error: GeminiErrorResponse?
}

struct GeminiCandidate: Codable {
  let content: GeminiContent
}

struct GeminiErrorResponse: Codable {
  let message: String
  let status: String?
}

// MARK: - GeminiClient

final class GeminiClient: RephraseProviding {
  private let apiKey: String
  private let model: String
  private let systemPrompt: String
  private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models"

  init(apiKey: String, model: String = "gemini-2.0-flash", systemPrompt: String) {
    self.apiKey = apiKey
    self.model = model
    self.systemPrompt = systemPrompt
  }

  func rephrase(text: String) async throws -> String {
    guard !apiKey.isEmpty else {
      throw AIProviderError.missingAPIKey
    }

    guard let url = URL(string: "\(baseURL)/\(model):generateContent?key=\(apiKey)") else {
      throw AIProviderError.invalidURL
    }

    let requestBody = GeminiRequest(
      contents: [
        GeminiContent(parts: [GeminiPart(text: "Text to improve:\n\(text)")])
      ],
      systemInstruction: GeminiContent(parts: [GeminiPart(text: systemPrompt)])
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

    let geminiResponse: GeminiResponse
    do {
      geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
    } catch {
      throw AIProviderError.decodingError(error)
    }

    if let error = geminiResponse.error {
      throw AIProviderError.serverError(error.message)
    }

    guard httpResponse.statusCode == 200 else {
      let errorMessage = geminiResponse.error?.message ?? "Unknown error (status: \(httpResponse.statusCode))"
      throw AIProviderError.serverError(errorMessage)
    }

    guard let candidate = geminiResponse.candidates?.first,
          let text = candidate.content.parts.first?.text else {
      throw AIProviderError.invalidResponse
    }

    return text.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
