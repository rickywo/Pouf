# Configurable AI Providers - Implementation Plan

## Phase 1: Backend Architecture & Core Logic

-   [x] **1.1: Define Provider Interface:**
    -   [x] Create a `RephraseProviding` protocol that defines a standard `rephrase(text: String)` function.

-   [x] **1.2: Refactor Existing Ollama Client:**
    -   [x] Modify `OllamaClient.swift` to conform to the `RephraseProviding` protocol.
    -   [x] Ensure existing rephrase functionality works with the new protocol.

-   [x] **1.3: Implement New Provider Clients:**
    -   [x] Create `GeminiClient.swift` that conforms to `RephraseProviding` and handles communication with the Gemini API.
    -   [x] Create `GrokClient.swift` that conforms to `RephraseProviding` and handles communication with the Grok API.

-   [x] **1.4: Create Provider Factory:**
    -   [x] Implement an `AIProviderFactory` or similar service that returns the currently active `RephraseProviding` instance based on application settings.

## Phase 2: Settings & Data Persistence

-   [x] **2.1: Update Application Settings Model:**
    -   [x] Add properties to `AppSettings.swift` to store the selected AI provider (e.g., `activeProvider: AIProviderType`).
    -   [x] Define an `AIProviderType` enum (`ollama`, `gemini`, `grok`).

-   [x] **2.2: Secure Credential Storage:**
    -   [x] Create a `KeychainManager` class to securely save and retrieve API keys for Gemini and Grok.
    -   [x] Add functions to `KeychainManager`: `saveAPIKey(_:forProvider:)` and `getAPIKey(forProvider:)`.

## Phase 3: Frontend UI Development

-   [x] **3.1: Build Provider Settings View:**
    -   [x] Create a new SwiftUI view file: `AIProviderSettingsView.swift`.
    -   [x] Add a picker control bound to the `activeProvider` setting.
    -   [x] Add a section for "Gemini" with a `SecureField` for the API key.
    -   [x] Add a section for "Grok" with a `SecureField` for the API key.
    -   [x] Implement logic to load/save keys using `KeychainManager` and update settings in `AppSettings`.

-   [x] **3.2: Integrate into Main Settings:**
    -   [x] Add a `NavigationLink` from `SettingsView.swift` to the new `AIProviderSettingsView`.
    -   [x] Ensure the navigation and layout are consistent with the existing settings screen.

## Phase 4: Integration and Testing

-   [x] **4.1: Update Rephrase Feature:**
    -   [x] Modify the view or controller responsible for the rephrase action.
    -   [x] Replace the direct call to `OllamaClient` with a call to the `AIProviderFactory` to get the current provider.
    -   [x] Use the returned provider to perform the rephrase operation.

-   [ ] **4.2: Unit & Integration Testing:**
    -   [ ] Write unit tests for `GeminiClient` and `GrokClient` using mock API responses.
    -   [ ] Write unit tests for the `AIProviderFactory` to ensure it returns the correct provider.
    -   [ ] Write tests for `KeychainManager` to verify secure storage access.

-   [ ] **4.3: End-to-End (E2E) Testing:**
    -   [ ] Manually test the complete user flow:
        -   [ ] Navigate to the new settings screen.
        -   [ ] Enter and save an API key for Gemini.
        -   [ ] Set Gemini as the active provider.
        -   [ ] Verify the rephrase feature successfully uses the Gemini client.
        -   [ ] Repeat the flow for Grok.
        -   [ ] Repeat the flow for Ollama to ensure no regressions.
