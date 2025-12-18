import AppKit
import SwiftUI

// MARK: - ShortcutRecorderView

struct ShortcutRecorderView: View {
  @Binding var shortcut: KeyboardShortcut
  @State private var isRecording = false
  @State private var showError = false
  @State private var errorMessage = ""

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 12) {
        // Shortcut display box
        ShortcutDisplayBox(
          shortcut: shortcut,
          isRecording: isRecording
        )
        .onTapGesture {
          startRecording()
        }

        // Reset button
        Button(action: resetToDefault) {
          Image(systemName: "arrow.counterclockwise")
            .foregroundColor(.secondary)
        }
        .buttonStyle(.plain)
        .help("Reset to default (⌘⌥/)")
        .disabled(shortcut == .default)
      }

      // Instructions
      if isRecording {
        Text("Press your desired shortcut keys...")
          .font(.caption)
          .foregroundColor(.orange)
      } else {
        Text("Click to change shortcut")
          .font(.caption)
          .foregroundColor(.secondary)
      }

      // Error message
      if showError {
        Text(errorMessage)
          .font(.caption)
          .foregroundColor(.red)
      }
    }
    .background(
      ShortcutRecorderHelper(
        isRecording: $isRecording,
        onShortcutRecorded: handleShortcutRecorded
      )
    )
  }

  private func startRecording() {
    isRecording = true
    showError = false
  }

  private func resetToDefault() {
    shortcut = .default
    isRecording = false
    showError = false
  }

  private func handleShortcutRecorded(_ newShortcut: KeyboardShortcut) {
    if newShortcut.isValid {
      shortcut = newShortcut
      isRecording = false
      showError = false
    } else {
      errorMessage = "Shortcut must include ⌘ or ⌃ modifier"
      showError = true
      isRecording = false
    }
  }
}

// MARK: - ShortcutDisplayBox

struct ShortcutDisplayBox: View {
  let shortcut: KeyboardShortcut
  let isRecording: Bool

  var body: some View {
    HStack(spacing: 4) {
      if isRecording {
        Text("Recording...")
          .foregroundColor(.orange)
      } else {
        Text(shortcut.displayString)
          .fontWeight(.medium)
      }
    }
    .font(.system(size: 14, design: .rounded))
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .frame(minWidth: 100)
    .background(
      RoundedRectangle(cornerRadius: 8)
        .fill(isRecording ? Color.orange.opacity(0.1) : Color.secondary.opacity(0.1))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(isRecording ? Color.orange : Color.secondary.opacity(0.3), lineWidth: 1)
    )
  }
}

// MARK: - ShortcutRecorderHelper (NSViewRepresentable)

struct ShortcutRecorderHelper: NSViewRepresentable {
  @Binding var isRecording: Bool
  var onShortcutRecorded: (KeyboardShortcut) -> Void

  func makeNSView(context: Context) -> ShortcutRecorderNSView {
    let view = ShortcutRecorderNSView()
    view.onShortcutRecorded = onShortcutRecorded
    return view
  }

  func updateNSView(_ nsView: ShortcutRecorderNSView, context: Context) {
    nsView.isRecordingEnabled = isRecording
    nsView.onShortcutRecorded = onShortcutRecorded

    if isRecording {
      DispatchQueue.main.async {
        nsView.window?.makeFirstResponder(nsView)
      }
    }
  }
}

// MARK: - ShortcutRecorderNSView

final class ShortcutRecorderNSView: NSView {
  var isRecordingEnabled = false
  var onShortcutRecorded: ((KeyboardShortcut) -> Void)?

  override var acceptsFirstResponder: Bool { true }

  override func keyDown(with event: NSEvent) {
    guard isRecordingEnabled else {
      super.keyDown(with: event)
      return
    }

    // Ignore modifier-only key presses
    let modifierOnlyKeyCodes: Set<UInt16> = [54, 55, 56, 57, 58, 59, 60, 61, 62, 63]
    if modifierOnlyKeyCodes.contains(event.keyCode) {
      return
    }

    // Escape cancels recording
    if event.keyCode == 53 {
      isRecordingEnabled = false
      return
    }

    let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
    var cgModifiers: Int = 0

    if modifiers.contains(.command) {
      cgModifiers |= Int(CGEventFlags.maskCommand.rawValue)
    }
    if modifiers.contains(.option) {
      cgModifiers |= Int(CGEventFlags.maskAlternate.rawValue)
    }
    if modifiers.contains(.control) {
      cgModifiers |= Int(CGEventFlags.maskControl.rawValue)
    }
    if modifiers.contains(.shift) {
      cgModifiers |= Int(CGEventFlags.maskShift.rawValue)
    }

    let newShortcut = KeyboardShortcut(
      keyCode: Int(event.keyCode),
      modifiers: cgModifiers
    )

    onShortcutRecorded?(newShortcut)
  }
}
