import SwiftUI

struct SettingsView: View {
  @ObservedObject var permissions: PermissionManager
  @ObservedObject var settings: AppSettings

  var body: some View {
    TabView {
      GeneralSettingsView(permissions: permissions)
        .tabItem {
          Label("General", systemImage: "gear")
        }

      AIProviderSettingsView(settings: settings)
        .tabItem {
          Label("AI Provider", systemImage: "brain")
        }

      PromptSettingsView(settings: settings)
        .tabItem {
          Label("Prompt", systemImage: "text.quote")
        }
    }
    .frame(width: 500, height: 380)
  }
}

// MARK: - GeneralSettingsView

struct GeneralSettingsView: View {
  @ObservedObject var permissions: PermissionManager

  var body: some View {
    Form {
      Section {
        if !permissions.isTrusted {
          HStack {
            Image(systemName: "exclamationmark.triangle.fill")
              .foregroundColor(.orange)
            Text("Accessibility permission required")
            Spacer()
            Button("Grant Access") {
              permissions.promptForAccess()
            }
          }
        } else {
          HStack {
            Image(systemName: "checkmark.circle.fill")
              .foregroundColor(.green)
            Text("Accessibility access granted")
          }
        }
      } header: {
        Text("Permissions")
      }

      Section {
        Text("Use **⌘⌥/** to fix selected text with AI")
          .font(.callout)
      } header: {
        Text("Usage")
      }
    }
    .formStyle(.grouped)
    .padding()
  }
}

// MARK: - AIProviderSettingsView

struct AIProviderSettingsView: View {
  @ObservedObject var settings: AppSettings
  @State private var selectedProvider: AIProviderType = .ollama
  @State private var testStatus = ""
  @State private var isTesting = false
  @State private var geminiAPIKey = ""
  @State private var grokAPIKey = ""

  private let keychainManager = KeychainManager()

  var body: some View {
    Form {
      Section {
        Picker("Active Provider", selection: $selectedProvider) {
          ForEach(AIProviderType.allCases, id: \.self) { provider in
            Text(provider.displayName).tag(provider)
          }
        }
        .pickerStyle(.segmented)
        .onChange(of: selectedProvider) { _, newValue in
          settings.activeProvider = newValue
          testStatus = ""
        }
      } header: {
        Text("Select Provider")
      }

      switch selectedProvider {
      case .ollama:
        Section {
          TextField("URL", text: $settings.ollamaURL)
            .textFieldStyle(.roundedBorder)
          TextField("Model", text: $settings.ollamaModel)
            .textFieldStyle(.roundedBorder)
        } header: {
          Text("Ollama Configuration")
        } footer: {
          Text("Ollama runs locally. No API key required.")
            .font(.caption)
            .foregroundStyle(.secondary)
        }

      case .gemini:
        Section {
          SecureField("API Key", text: $geminiAPIKey)
            .textFieldStyle(.roundedBorder)
            .onChange(of: geminiAPIKey) { _, newValue in
              keychainManager.saveAPIKey(newValue, for: .gemini)
            }
          TextField("Model", text: $settings.geminiModel)
            .textFieldStyle(.roundedBorder)
        } header: {
          Text("Gemini Configuration")
        } footer: {
          Text("Get your API key from Google AI Studio.")
            .font(.caption)
            .foregroundStyle(.secondary)
        }

      case .grok:
        Section {
          SecureField("API Key", text: $grokAPIKey)
            .textFieldStyle(.roundedBorder)
            .onChange(of: grokAPIKey) { _, newValue in
              keychainManager.saveAPIKey(newValue, for: .grok)
            }
          TextField("Model", text: $settings.grokModel)
            .textFieldStyle(.roundedBorder)
        } header: {
          Text("Grok Configuration")
        } footer: {
          Text("Get your API key from x.ai.")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }

      Section {
        HStack {
          Button("Test Connection") {
            testConnection()
          }
          .disabled(isTesting || !canTest)

          if isTesting {
            ProgressView()
              .scaleEffect(0.7)
          }

          if !testStatus.isEmpty {
            Text(testStatus)
              .font(.caption)
              .foregroundColor(testStatus.contains("Success") ? .green : .red)
          }
        }
      }
    }
    .formStyle(.grouped)
    .padding()
    .onAppear {
      selectedProvider = settings.activeProvider
      loadAPIKeys()
    }
  }

  private var canTest: Bool {
    switch selectedProvider {
    case .ollama:
      return !settings.ollamaURL.isEmpty
    case .gemini:
      return !geminiAPIKey.isEmpty
    case .grok:
      return !grokAPIKey.isEmpty
    }
  }

  private func loadAPIKeys() {
    geminiAPIKey = keychainManager.getAPIKey(for: .gemini) ?? ""
    grokAPIKey = keychainManager.getAPIKey(for: .grok) ?? ""
  }

  private func testConnection() {
    isTesting = true
    testStatus = ""

    Task {
      do {
        let factory = AIProviderFactory(settings: settings, keychainManager: keychainManager)
        let provider = try factory.makeProvider()
        let response = try await provider.rephrase(text: "Hello world")

        await MainActor.run {
          let preview = response.prefix(30)
          testStatus = "Success: \(preview)..."
          isTesting = false
        }
      } catch {
        await MainActor.run {
          testStatus = "Error: \(error.localizedDescription)"
          isTesting = false
        }
      }
    }
  }
}

// MARK: - PromptSettingsView

struct PromptSettingsView: View {
  @ObservedObject var settings: AppSettings

  var body: some View {
    Form {
      Section {
        TextEditor(text: $settings.systemPrompt)
          .font(.body)
          .frame(height: 120)
          .border(Color.secondary.opacity(0.3), width: 1)
      } header: {
        Text("System Prompt")
      } footer: {
        Text("This prompt instructs the AI how to process your text.")
          .font(.caption)
          .foregroundStyle(.secondary)
      }

      Section {
        Button("Reset to Default") {
          settings.systemPrompt = "Fix grammar and make it sound professional. Only return the corrected text, nothing else."
        }
      }
    }
    .formStyle(.grouped)
    .padding()
  }
}
