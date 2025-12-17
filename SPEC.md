# Project Specification: Pouf (MVP)

**Version:** 0.1 (MVP)
**Platform:** macOS (Native)
**License:** MIT / Apache 2.0
**Status:** Development

## 1. Executive Summary

Pouf is a macOS-native background application designed to provide system-wide, privacy-first AI text enhancement. It allows users to select text in any application (Slack, Xcode, Chrome, Notes) and instantly rephrase, fix, or improve it using a local LLM.

Unlike traditional writing tools that require copy-pasting into a separate window, Pouf functions as an invisible layer over the OS, capturing selected text and replacing it in-place via keyboard simulation.

## 2. Core Architecture

The project utilizes keyboard event monitoring to detect the global hotkey and clipboard operations to capture and replace selected text.

### Tech Stack

- **Language:** Swift 6
- **UI Framework:** SwiftUI (for settings panel)
- **OS Integration:**
  - CoreGraphics (CGEvent): To monitor global shortcuts
  - Clipboard (NSPasteboard): To capture and inject text
- **AI Backend:**
  - Protocol: HTTP/REST (connecting to localhost)
  - Engine: Ollama (Required external dependency for MVP)
  - Model: Llama 3 or Mistral (Optimized for latency)

## 3. MVP Definitions (Minimum Viable Product)

The MVP achieves one specific flow: **Select -> Trigger -> Replace**

### 3.1 Functional Requirements

- **Global Activation:** The app runs in the menu bar (no dock icon)
- **Hotkey Trigger:** `Cmd + Option + /` triggers the action on selected text
- **In-Place Replacement:**
  1. Upon trigger, the app copies selected text via simulated Cmd+C
  2. Sends text to Ollama
  3. Replaces the selection by pasting the AI-improved text via simulated Cmd+V
  4. Restores original clipboard contents
- **Settings Panel:**
  - Field to set Ollama URL (default: `http://localhost:11434`)
  - Field to set Model name (default: `llama3`)
  - Field to set System Prompt (e.g., "Fix grammar and make it sound professional")

### 3.2 Non-Functional Requirements

- **Latency:** Total round-trip time (Trigger to Response) should be under 2 seconds
- **Privacy:** Zero data leaves the local machine
- **Permissions:** Must gracefully handle "Accessibility" and "Input Monitoring" permission requests on first launch

## 4. User Workflow (The "Happy Path")

1. **Setup:** User installs Pouf and Ollama
2. **Drafting:** User opens Slack and types a messy message: `hey boss, i cant come today, im sick`
3. **Selection:** User selects the text
4. **Trigger:** User presses `⌘⌥/`
5. **Processing:** The selected text is sent to the local AI
6. **Result:** The text is replaced with: `Hi, I won't be able to make it in today as I'm feeling under the weather.`

## 5. Technical Implementation Details

### 5.1 The "Watcher" (Input Monitor)

This component runs in the background using `CGEvent.tapCreate`. It listens only for the global hotkey combination.

```swift
// Hotkey detection
if keyCode == hotkeyKeyCode &&
   flags.contains(.maskCommand) &&
   flags.contains(.maskAlternate) {
  triggerHotkeyFix()
}
```

### 5.2 The "Replacer" (Text Injector)

Replacing text uses the Clipboard Strategy:

1. **Save Clipboard:** Store current clipboard contents
2. **Copy Selection:** Simulate `Cmd+C` to copy selected text
3. **Process:** Send text to AI, get result
4. **Inject:** Write result to clipboard, simulate `Cmd+V` to paste
5. **Restore Clipboard:** Restore original clipboard contents

### 5.3 The AI Client

The app acts as a simple REST client interacting with the local Ollama instance.

- **Endpoint:** `POST /api/generate`
- **Payload:**
```json
{
  "model": "llama3",
  "prompt": "Rewrite this to be professional: [USER_TEXT]",
  "stream": false
}
```

## 6. Project Structure

```
Pouf/
├── PoufApp.swift         # App entry point, menu bar setup
├── AppSettings.swift     # User settings with UserDefaults persistence
├── InputMonitor.swift    # Global hotkey detection
├── TextInjector.swift    # Keyboard simulation for copy/paste
├── OllamaClient.swift    # REST client for Ollama API
├── PermissionManager.swift # Accessibility permission handling
└── SettingsView.swift    # SwiftUI settings panel
```
