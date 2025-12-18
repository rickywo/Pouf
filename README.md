# Pouf

> A native macOS menu bar app that brings AI text enhancement to any application. Select text and press a hotkey to rewrite it in-place using local or cloud AI.

[![macOS](https://img.shields.io/badge/macOS-14.0+-blue?logo=apple)](https://www.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-6-orange?logo=swift)](https://swift.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## About

Pouf is a lightweight, open-source macOS utility that functions as a system-wide AI writing layer. Unlike other tools that require you to copy-paste text into a separate window, Pouf works in-place within your existing workflow—whether you are in Slack, Xcode, Notes, or Chrome.

Built with SwiftUI and the Accessibility API, it runs silently in the background. Simply use a global hotkey, and Pouf will capture your selected text, send it to your configured AI provider, and replace your draft with a polished version instantly.

## Key Features

- **Universal Compatibility:** Works in any text field on macOS
- **Privacy First:** Zero data leaves your machine when using Ollama (local AI)
- **Multiple AI Providers:** Choose between Ollama (local), Gemini, or Grok
- **Native Performance:** Built in Swift 6 with no Electron bloat
- **Invisible Interface:** No floating windows or distractions—just select and go
- **Customizable Shortcuts:** Configure your preferred keyboard shortcut
- **Secure Storage:** API keys stored in macOS Keychain

## Installation

1. Download the latest release from the [Releases](https://github.com/rickywo/Pouf/releases) page
2. Move `Pouf.app` to your Applications folder
3. Launch Pouf—it will appear in your menu bar
4. Grant Accessibility permissions when prompted

For detailed setup instructions, see the [User Guide](docs/USER_GUIDE.md).

## Quick Start

1. **Configure your AI provider** in Settings > AI Provider
   - **Ollama** (local, free): No API key required
   - **Gemini** or **Grok** (cloud): Enter your API key

2. **Select any text** in any application

3. **Press your hotkey** (default: `⌘⌥/`)

4. **Watch your text transform** into polished, professional writing

## Screenshots

| Menu Bar | General Settings | AI Provider | Prompt |
|----------|------------------|-------------|--------|
| ![Menu Bar](docs/snapshots/menu-bar.png) | ![General](docs/snapshots/settings-general.png) | ![AI Provider](docs/snapshots/settings-ai-provider.png) | ![Prompt](docs/snapshots/settings-prompt.png) |

## Requirements

- macOS 14.0 or later
- For local AI: [Ollama](https://ollama.ai) installed and running
- For cloud AI: API key from [Google AI Studio](https://aistudio.google.com/) (Gemini) or [x.ai](https://x.ai/) (Grok)

## Building from Source

```bash
# Clone the repository
git clone https://github.com/rickywo/Pouf.git
cd Pouf

# Open in Xcode
open Pouf.xcodeproj

# Build and run (⌘R)
```

## Documentation

- [User Guide](docs/USER_GUIDE.md) - Complete usage instructions
- [Documentation](docs/README.md) - Documentation structure

## Privacy

- **Ollama:** All processing happens locally. Your text never leaves your machine.
- **Gemini/Grok:** Text is sent to cloud APIs for processing. Review their privacy policies.
- API keys are stored securely in the macOS Keychain.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## GitHub Topics

Add these topics to your repository settings for discoverability:

```
macos swift swiftui accessibility-api ai-assistant ollama gemini grok local-llm productivity text-enhancement writing-tool menu-bar-app
```
