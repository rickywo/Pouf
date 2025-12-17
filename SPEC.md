# Project Specification: Pouf

**Version:** 0.2
**Platform:** macOS (Native)
**License:** MIT / Apache 2.0
**Status:** Development

## 1. Executive Summary

Pouf is a macOS-native background application designed to provide system-wide AI text enhancement. It allows users to select text in any application (Slack, Xcode, Chrome, Notes) and instantly rephrase, fix, or improve it using their choice of AI provider.

Unlike traditional writing tools that require copy-pasting into a separate window, Pouf functions as an invisible layer over the OS, capturing selected text and replacing it in-place via keyboard simulation.

## 2. Core Architecture

The project utilizes keyboard event monitoring to detect the global hotkey and clipboard operations to capture and replace selected text.

### Tech Stack

- **Language:** Swift 6
- **UI Framework:** SwiftUI (for settings panel)
- **OS Integration:**
  - CoreGraphics (CGEvent): To monitor global shortcuts
  - Clipboard (NSPasteboard): To capture and inject text
  - Security (Keychain): To securely store API keys
- **AI Backend:**
  - Protocol: HTTP/REST
  - Supported Providers:
    - Ollama (local)
    - Gemini (Google AI)
    - Grok (xAI)

## 3. Functional Requirements

The app achieves one specific flow: **Select -> Trigger -> Replace**

### 3.1 Core Features

- **Global Activation:** The app runs in the menu bar (no dock icon)
- **Hotkey Trigger:** `Cmd + Option + /` triggers the action on selected text
- **In-Place Replacement:**
  1. Upon trigger, the app copies selected text via simulated Cmd+C
  2. Sends text to the configured AI provider
  3. Replaces the selection by pasting the AI-improved text via simulated Cmd+V
  4. Restores original clipboard contents

### 3.2 Multi-Provider Support

- **Provider Selection:** Users can choose between Ollama, Gemini, or Grok
- **Provider-Specific Settings:**
  - Ollama: URL and model name
  - Gemini: API key and model name
  - Grok: API key and model name
- **Secure Storage:** API keys are stored in the macOS Keychain

### 3.3 Settings Panel

- **General Tab:** Permission status and usage instructions
- **AI Provider Tab:** Provider selection and configuration
- **Prompt Tab:** Customizable system prompt

### 3.4 Non-Functional Requirements

- **Latency:** Total round-trip time should be under 2 seconds (varies by provider)
- **Privacy:** Ollama keeps data local; cloud providers send text to their APIs
- **Permissions:** Must gracefully handle "Accessibility" and "Input Monitoring" permission requests

## 4. User Workflow

1. **Setup:** User installs Pouf and configures their preferred AI provider
2. **Drafting:** User opens any app and types text
3. **Selection:** User selects the text to improve
4. **Trigger:** User presses `⌘⌥/`
5. **Processing:** The selected text is sent to the configured AI
6. **Result:** The text is replaced with the improved version

## 5. Technical Implementation Details

### 5.1 Provider Architecture

```swift
// Protocol for all AI providers
protocol RephraseProviding {
  func rephrase(text: String) async throws -> String
}

// Factory creates the appropriate provider
final class AIProviderFactory {
  func makeProvider() throws -> RephraseProviding
}
```

### 5.2 The "Watcher" (Input Monitor)

Runs in the background using `CGEvent.tapCreate`, listening for the global hotkey.

### 5.3 The "Replacer" (Text Injector)

Replacing text uses the Clipboard Strategy:

1. **Save Clipboard:** Store current clipboard contents
2. **Copy Selection:** Simulate `Cmd+C` to copy selected text
3. **Process:** Send text to AI provider, get result
4. **Inject:** Write result to clipboard, simulate `Cmd+V` to paste
5. **Restore Clipboard:** Restore original clipboard contents

## 6. Project Structure

```
Pouf/
├── PoufApp.swift           # App entry point, menu bar setup
├── AppSettings.swift       # User settings with UserDefaults persistence
├── InputMonitor.swift      # Global hotkey detection
├── TextInjector.swift      # Keyboard simulation for copy/paste
├── PermissionManager.swift # Accessibility permission handling
├── SettingsView.swift      # SwiftUI settings panel
│
├── AIProvider.swift        # Protocol and common types
├── AIProviderFactory.swift # Factory for creating providers
├── OllamaClient.swift      # Ollama REST client
├── GeminiClient.swift      # Gemini REST client
├── GrokClient.swift        # Grok REST client
└── KeychainManager.swift   # Secure API key storage
```
