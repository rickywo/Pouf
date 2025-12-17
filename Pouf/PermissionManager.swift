import AppKit
import ApplicationServices
import Combine

final class PermissionManager: ObservableObject {
  var objectWillChange = ObservableObjectPublisher()

  @Published var isTrusted: Bool

  init() {
    self.isTrusted = AXIsProcessTrusted()
  }

  func checkAccess() {
    isTrusted = AXIsProcessTrusted()
  }

  func promptForAccess() {
    let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
    AXIsProcessTrustedWithOptions(options)
  }
}
