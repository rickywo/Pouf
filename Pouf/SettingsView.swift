import SwiftUI

struct SettingsView: View {
  @ObservedObject var permissions: PermissionManager
  @ObservedObject var inputMonitor: InputMonitor
  @ObservedObject var settings: AppSettings
  @State private var testStatus = ""
  @State private var isTesting = false

  var body: some View {
    TabView {
      GeneralSettingsView(permissions: permissions, inputMonitor: inputMonitor)
        .tabItem {
          Label("General", systemImage: "gear")
        }

      AISettingsView(settings: settings, testStatus: $testStatus, isTesting: $isTesting)
        .tabItem {
          Label("AI", systemImage: "brain")
        }
    }
    .frame(width: 450, height: 320)
  }
}

// MARK: - GeneralSettingsView

struct GeneralSettingsView: View {
  @ObservedObject var permissions: PermissionManager
  @ObservedObject var inputMonitor: InputMonitor

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
        VStack(alignment: .leading, spacing: 8) {
          Text("Type **::fix** after any text to trigger AI enhancement")
            .font(.callout)
          Text("Or use **⌘⌥/** to fix selected text")
            .font(.callout)
        }
      } header: {
        Text("Usage")
      }

      Section {
        Text(inputMonitor.lastKeyLog.isEmpty ? "No input yet..." : inputMonitor.lastKeyLog)
          .font(.caption)
          .foregroundStyle(.secondary)
          .lineLimit(2)
      } header: {
        Text("Last Typed (Debug)")
      }
    }
    .formStyle(.grouped)
    .padding()
  }
}

// MARK: - AISettingsView

struct AISettingsView: View {
  @ObservedObject var settings: AppSettings
  @Binding var testStatus: String
  @Binding var isTesting: Bool

  var body: some View {
    Form {
      Section {
        TextField("URL", text: $settings.ollamaURL)
          .textFieldStyle(.roundedBorder)
        TextField("Model", text: $settings.ollamaModel)
          .textFieldStyle(.roundedBorder)

        HStack {
          Button("Test Connection") {
            testConnection()
          }
          .disabled(isTesting)

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
      } header: {
        Text("Ollama Configuration")
      }

      Section {
        TextEditor(text: $settings.systemPrompt)
          .font(.body)
          .frame(height: 80)
          .border(Color.secondary.opacity(0.3), width: 1)
      } header: {
        Text("System Prompt")
      }
    }
    .formStyle(.grouped)
    .padding()
  }

  private func testConnection() {
    isTesting = true
    testStatus = ""

    Task {
      let client = OllamaClient(
        baseURL: settings.ollamaURL,
        model: settings.ollamaModel,
        systemPrompt: "Reply with just: OK"
      )

      do {
        let response = try await client.generate(text: "test")
        await MainActor.run {
          testStatus = "Success: \(response.prefix(20))..."
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
