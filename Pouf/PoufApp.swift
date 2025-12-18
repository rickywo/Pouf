import SwiftUI

@main
struct PoufApp: App {
  @StateObject private var permissions = PermissionManager()
  @StateObject private var settings: AppSettings
  @StateObject private var inputMonitor: InputMonitor

  init() {
    let appSettings = AppSettings()
    _settings = StateObject(wrappedValue: appSettings)
    _inputMonitor = StateObject(wrappedValue: InputMonitor(settings: appSettings))
  }

  var body: some Scene {
    MenuBarExtra("Pouf", systemImage: "wand.and.stars") {
      Button("Fix Selection") {
        // Manual trigger via hotkey
      }
      .keyboardShortcut("/", modifiers: [.command, .option])

      Divider()

      SettingsLink {
        Text("Settings...")
      }
      .keyboardShortcut(",", modifiers: .command)

      Button("Quit") {
        NSApplication.shared.terminate(nil)
      }
      .keyboardShortcut("q")
    }

    Settings {
      SettingsView(permissions: permissions, settings: settings)
    }
  }
}
