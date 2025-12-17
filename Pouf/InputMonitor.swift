import AppKit
import Combine

@MainActor
final class InputMonitor: ObservableObject {
  nonisolated let objectWillChange = ObservableObjectPublisher()

  @Published var isProcessing = false

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
    guard keyCode == hotkeyKeyCode,
          flags.contains(.maskCommand),
          flags.contains(.maskAlternate) else { return }

    Task { @MainActor in
      self.triggerHotkeyFix()
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

    // Use AIProviderFactory to get the active provider
    let settings = AppSettings()
    let factory = AIProviderFactory(settings: settings)

    do {
      let provider = try factory.makeProvider()
      let improvedText = try await provider.rephrase(text: selectedText)
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
}
