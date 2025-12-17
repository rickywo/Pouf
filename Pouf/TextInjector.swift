import AppKit

final class TextInjector {
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
