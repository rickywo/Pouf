Project Specification: Pouf (MVP)
Version: 0.1 (MVP)
Platform: macOS (Native)
License: MIT / Apache 2.0
Status: Planning Phase
1. Executive Summary
   Pouf is a macOS-native background application designed to provide system-wide, privacy-first AI text enhancement. It allows users to type in any application (Slack, Xcode, Chrome, Notes) and instantly rephrase, fix, or autocomplete their text using a local LLM.
   Unlike traditional writing tools that require copy-pasting into a separate window, Pouf functions as an invisible layer over the OS, intercepting text input and replacing it in-place via Accessibility APIs.
2. Core Architecture
   The project utilizes the Accessibility Overlay approach to ensure compatibility across all applications without requiring specific integrations for each one.
   The Tech Stack
   Language: Swift 6
   UI Framework: SwiftUI (for settings & floating HUD)
   OS Integration:
   CoreGraphics (CGEvent): To monitor keystrokes and global shortcuts.
   Accessibility API (AXUIElement): To read context and replace text.
   AI Backend:
   Protocol: HTTP/REST (connecting to localhost).
   Engine: Ollama (Required external dependency for MVP).
   Model: Llama 3 or Mistral (Optimized for latency).
3. MVP Definitions (Minimum Viable Product)
   The MVP must achieve one specific flow perfectly: Type -> Trigger -> Replace.
   3.1 Functional Requirements
   Global Activation: The app runs in the menu bar (no dock icon).
   Input Buffering: The app silently tracks the last 300 characters typed by the user to understand context.
   The Trigger:
   Hot Key: Cmd + Option + / (configurable).
   Magic Command: Typing ::fix triggers the action on the preceding sentence.
   In-Place Replacement:
   Upon trigger, the app captures the text.
   Sends text to Ollama.
   Deletes the user's original text (simulating Backspace key events).
   Simulates typing the new AI-improved text or pastes it via Clipboard.
   Settings Panel:
   Field to set Ollama URL (default: http://localhost:11434).
   Field to set System Prompt (e.g., "Fix grammar and make it sound professional").
   3.2 Non-Functional Requirements
   Latency: Total round-trip time (Trigger to Response) must be under 1.5 seconds.
   Privacy: Zero data leaves the local machine.
   Permissions: Must gracefully handle "Accessibility" and "Input Monitoring" permission requests on first launch.
4. User Workflow (The "Happy Path")
   Setup: User installs Pouf and Ollama.
   Drafting: User opens Slack and types a messy message:hey boss, i cant come today, im sick.
   Trigger: User types ::fix (or hits the hotkey).
   Processing:
   A tiny loading spinner appears near the text cursor (optional for MVP, essential for V1).
   The text hey boss, i cant come today, im sick. is automatically deleted by the system.
   Result: The AI streams the response back into the text field:Hi, I won't be able to make it in today as I'm feeling under the weather.
5. Technical Implementation Details
   5.1 The "Watcher" (Input Manager)
   This component runs in the background using CGEvent.tapCreate. It buffers standard text while ignoring secure input fields (password boxes).
   // Logic for InputBuffer
   class InputBuffer {
   var buffer: String = ""

   func handleKey(_ key: String) {
   if key == "Backspace" {
   buffer.removeLast()
   } else {
   buffer.append(key)
   }

        // Check for Magic Trigger
        if buffer.hasSuffix("::fix") {
            let targetText = buffer.dropLast(5) // Remove trigger
            triggerAI(for: targetText)
        }
   }
   }


5.2 The "Replacer" (Accessibility Engine)
Replacing text "in-place" is the hardest technical challenge. The MVP will use the Clipboard Strategy as a universal fallback.
The "Universal Paste" Strategy:
Save Clipboard: let oldClip = NSPasteboard.general
Select Text: Simulate Cmd + Shift + Left_Arrow (to select the line).
Process: Send text to AI -> Get result.
Inject: Write result to Clipboard -> Simulate Cmd + V.
Restore Clipboard: Restore oldClip.
5.3 The AI Client
The app will act as a simple REST Client interacting with the local Ollama instance.
Endpoint: POST /api/generate
Payload:
{
"model": "llama3",
"prompt": "Rewrite this to be professional: [USER_TEXT]",
"stream": false
}


6. Project Roadmap
   Phase
   Duration
   Goal
   Output
   Phase 1: Core
   Week 1-2
   Basic Key Listener
   App requests permissions; prints keystrokes to Xcode console.
   Phase 2: Connector
   Week 3
   AI Integration
   Typing ::test logs a response from Llama 3 to console.
   Phase 3: Injector
   Week 4
   Text Replacement
   ::fix successfully replaces text in TextEdit/Slack.
   Phase 4: Polish
   Week 5
   UI & Packaging
   Settings menu, loading indicator, and DMG creation.


