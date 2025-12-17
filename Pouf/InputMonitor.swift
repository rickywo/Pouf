import AppKit
import Combine

@MainActor
final class InputMonitor: ObservableObject {
  nonisolated let objectWillChange = ObservableObjectPublisher()

  @Published var lastKeyLog = ""
  @Published var isProcessing = false

  private var buffer = ""
  private var eventTap: CFMachPort?
  private let textInjector = TextInjector()
  private let hotkeyKeyCode: Int64 = 44 // Cmd + Option + / (keyCode 44)

  // MARK: - Initialization

  init() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
      self?.startMonitoring()
    }
  }

  // MARK: - Event Monitoring

  nonisolated func startMonitoring() {
    let eventMask = (1 << CGEventType.keyDown.rawValue)
    let refcon = Unmanaged.passUnretained(self).toOpaque()

    guard let tap = CGEvent.tapCreate(
      tap: .cgSessionEventTap,
      place: .headInsertEventTap,
      options: .defaultTap,
      eventsOfInterest: CGEventMask(eventMask),
      callback: { _, _, event, refcon -> Unmanaged<CGEvent>? in
        guard let refcon else { return Unmanaged.passRetained(event) }
        let monitor = Unmanaged<InputMonitor>.fromOpaque(refcon).takeUnretainedValue()
        monitor.handleEvent(event)
        return Unmanaged.passRetained(event)
      },
      userInfo: refcon
    ) else {
      print("Failed to create event tap. Do you have permissions?")
      return
    }

    let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
    CGEvent.tapEnable(tap: tap, enable: true)

    Task { @MainActor in
      self.eventTap = tap
    }
  }

  // MARK: - Event Handling

  nonisolated private func handleEvent(_ event: CGEvent) {
    let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
    let flags = event.flags

    // Check for hotkey: Cmd + Option + /
    if keyCode == hotkeyKeyCode &&
       flags.contains(.maskCommand) &&
       flags.contains(.maskAlternate) {
      Task { @MainActor in
        self.triggerHotkeyFix()
      }
      return
    }

    // Handle backspace (keyCode 51)
    if keyCode == 51 {
      Task { @MainActor in
        guard !self.buffer.isEmpty else { return }
        self.buffer.removeLast()
        self.lastKeyLog = self.buffer
      }
      return
    }

    guard let chars = event.getCharacters() else { return }

    Task { @MainActor in
      self.buffer.append(chars)

      // Keep buffer small (last 300 characters)
      if self.buffer.count > 300 {
        self.buffer = String(self.buffer.suffix(300))
      }

      self.lastKeyLog = self.buffer
      self.checkForTrigger()
    }
  }

  // MARK: - Hotkey Actions

  private func triggerHotkeyFix() {
    guard !isProcessing else { return }

    print("Hotkey triggered!")
    isProcessing = true

    Task {
      await performHotkeyReplacement()
      isProcessing = false
    }
  }

  private func performHotkeyReplacement() async {
    let pasteboard = NSPasteboard.general
    let oldContents = pasteboard.string(forType: .string)

    // Copy selected text (Cmd+C)
    textInjector.simulateKeyPress(keyCode: 8, modifiers: [.maskCommand])

    try? await Task.sleep(nanoseconds: 100_000_000) // 100ms

    // Get selected text from clipboard
    guard let selectedText = pasteboard.string(forType: .string),
          !selectedText.isEmpty,
          selectedText != oldContents else {
      print("No text selected")
      if let old = oldContents {
        pasteboard.clearContents()
        pasteboard.setString(old, forType: .string)
      }
      return
    }

    let settings = AppSettings()
    let client = OllamaClient(
      baseURL: settings.ollamaURL,
      model: settings.ollamaModel,
      systemPrompt: settings.systemPrompt
    )

    do {
      let improvedText = try await client.generate(text: selectedText)
      print("AI Response: \(improvedText)")

      // Paste improved text (replaces selection)
      pasteboard.clearContents()
      pasteboard.setString(improvedText, forType: .string)

      textInjector.simulateKeyPress(keyCode: 9, modifiers: [.maskCommand]) // Cmd+V

      try? await Task.sleep(nanoseconds: 100_000_000)
      if let old = oldContents {
        pasteboard.clearContents()
        pasteboard.setString(old, forType: .string)
      }
    } catch {
      print("AI Error: \(error.localizedDescription)")
      if let old = oldContents {
        pasteboard.clearContents()
        pasteboard.setString(old, forType: .string)
      }
    }
  }

  // MARK: - Trigger Detection

  private func checkForTrigger() {
    guard buffer.hasSuffix("::fix"), !isProcessing else { return }

    print("Trigger Detected!")

    let textBeforeTrigger = String(buffer.dropLast(5))

    // Find the text to fix (everything after last newline or start)
    let textToFix: String
    if let lastNewline = textBeforeTrigger.lastIndex(of: "\n") {
      textToFix = String(textBeforeTrigger[textBeforeTrigger.index(after: lastNewline)...])
    } else {
      textToFix = textBeforeTrigger
    }

    buffer = ""

    guard !textToFix.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      print("No text to fix")
      return
    }

    isProcessing = true

    Task {
      await performAIReplacement(originalText: textToFix)
      isProcessing = false
    }
  }

  private func performAIReplacement(originalText: String) async {
    let settings = AppSettings()
    let client = OllamaClient(
      baseURL: settings.ollamaURL,
      model: settings.ollamaModel,
      systemPrompt: settings.systemPrompt
    )

    do {
      let improvedText = try await client.generate(text: originalText)
      print("AI Response: \(improvedText)")

      // Calculate how many characters to delete: original text + "::fix"
      let charsToDelete = originalText.count + 5

      await textInjector.performReplacement(
        newText: improvedText,
        charsToDelete: charsToDelete
      )
    } catch {
      print("AI Error: \(error.localizedDescription)")
    }
  }
}

// MARK: - CGEvent Extension

extension CGEvent {
  nonisolated func getCharacters() -> String? {
    var length = 0
    keyboardGetUnicodeString(maxStringLength: 0, actualStringLength: &length, unicodeString: nil)

    guard length > 0 else { return nil }

    var chars = [UniChar](repeating: 0, count: length)
    keyboardGetUnicodeString(maxStringLength: length, actualStringLength: &length, unicodeString: &chars)

    return String(utf16CodeUnits: chars, count: length)
  }
}
