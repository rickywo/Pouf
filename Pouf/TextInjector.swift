import AppKit

final class TextInjector {
  func performReplacement(newText: String, charsToDelete: Int) async {
    let pasteboard = NSPasteboard.general
    let oldClipboardItems = pasteboard.pasteboardItems?.compactMap { item -> (NSPasteboard.PasteboardType, Data)? in
      guard let types = item.types.first,
            let data = item.data(forType: types) else { return nil }
      return (types, data)
    } ?? []

    // Delete the original text by simulating backspace key presses
    for _ in 0..<charsToDelete {
      simulateKeyPress(keyCode: 51) // 51 is Delete/Backspace
      try? await Task.sleep(nanoseconds: 10_000_000) // 10ms delay
    }

    try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

    // Copy new text to clipboard and paste
    pasteboard.clearContents()
    pasteboard.setString(newText, forType: .string)

    // Simulate Cmd+V to paste
    simulateKeyPress(keyCode: 9, modifiers: [.maskCommand]) // 9 is 'V'

    try? await Task.sleep(nanoseconds: 100_000_000) // 100ms

    // Restore original clipboard contents
    pasteboard.clearContents()
    for (type, data) in oldClipboardItems {
      pasteboard.setData(data, forType: type)
    }
  }

  func simulateKeyPress(keyCode: CGKeyCode, modifiers: CGEventFlags = []) {
    let source = CGEventSource(stateID: .hidSystemState)

    guard let keyDown = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: true),
          let keyUp = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: false) else {
      return
    }

    keyDown.flags = modifiers
    keyUp.flags = modifiers

    keyDown.post(tap: .cghidEventTap)
    keyUp.post(tap: .cghidEventTap)
  }
}
