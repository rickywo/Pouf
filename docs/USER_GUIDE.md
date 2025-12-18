# Pouf User Guide

Pouf is a macOS menu bar app that provides system-wide AI text enhancement. Select any text and instantly improve it using your choice of AI provider.

## Supported AI Providers

Pouf supports three AI providers:

| Provider | Type | API Key Required |
|----------|------|------------------|
| **Ollama** | Local | No |
| **Gemini** | Cloud | Yes |
| **Grok** | Cloud | Yes |

## Prerequisites

### Option 1: Ollama (Local, Free)

For privacy-focused local processing:

```bash
# Install Ollama
brew install ollama

# Start Ollama service
ollama serve

# Pull a model (recommended: llama3 or mistral)
ollama pull llama3
```

Verify Ollama is running by visiting: http://localhost:11434

### Option 2: Gemini (Cloud)

1. Visit [Google AI Studio](https://aistudio.google.com/)
2. Create an API key
3. Enter the key in Pouf Settings > AI Provider

### Option 3: Grok (Cloud)

1. Visit [x.ai](https://x.ai/)
2. Create an API key
3. Enter the key in Pouf Settings > AI Provider

### Grant Permissions

Pouf needs macOS permissions to monitor keyboard input and inject text.

1. Open **System Settings** > **Privacy & Security** > **Accessibility**
2. Click the **lock icon** to make changes
3. Enable **Pouf** in the list (click + to add if not visible)
4. Also check **Input Monitoring** and enable Pouf there

> **Note:** After granting permissions, restart Pouf for changes to take effect.

## Usage

### Fix Selected Text (⌘⌥/)

1. **Select** any text in any application
2. Press **⌘ + ⌥ + /** (Command + Option + /)
3. The selected text will be replaced with the AI-improved version

This works great for editing existing text in emails, documents, or chat apps.

**Example:**
1. Type: `hey boss, i cant come today, im sick`
2. Select the text
3. Press ⌘⌥/
4. Result: `Hi, I won't be able to make it in today as I'm feeling unwell.`

## Settings

Click the **Pouf icon** in the menu bar > **Settings** to configure:

### General Tab
- View permission status
- Usage instructions

### AI Provider Tab
- **Select Provider:** Choose between Ollama, Gemini, or Grok
- **Provider Configuration:** Settings specific to the selected provider
  - **Ollama:** URL and model name
  - **Gemini:** API key and model name
  - **Grok:** API key and model name
- **Test Connection:** Verify your provider is working

### Prompt Tab
- **System Prompt:** Customize how the AI processes your text
- **Reset to Default:** Restore the default prompt

### Default System Prompt
```
Fix grammar and make it sound professional. Only return the corrected text, nothing else.
```

### Custom Prompt Examples

**Casual/Friendly:**
```
Rewrite this to sound friendly and casual. Only return the corrected text.
```

**Technical Writing:**
```
Improve this text for technical documentation. Be clear and concise. Only return the corrected text.
```

**Email Professional:**
```
Rewrite this as a professional business email. Only return the corrected text.
```

## Troubleshooting

### "Failed to create event tap"
- Ensure Accessibility permissions are granted
- Toggle the permission OFF and ON again in System Settings
- Restart Pouf

### Text not being replaced
- Check that your provider is configured correctly
- Use "Test Connection" in Settings > AI Provider
- For Ollama: ensure the service is running (`ollama serve`)
- For Gemini/Grok: verify your API key is correct

### "API key is required"
- Go to Settings > AI Provider
- Enter your API key for Gemini or Grok
- Or switch to Ollama which doesn't require an API key

### Slow response
- For Ollama: try a smaller/faster model like `mistral` or `phi`
- For cloud providers: response time depends on network latency
- Ensure no other heavy processes are using your GPU/CPU

### Reset Permissions
If permissions aren't working, reset them via Terminal:
```bash
tccutil reset Accessibility com.pouf.app
```
Then re-grant permissions and restart the app.

## Tips

1. **Keep text short:** AI works best with sentences or short paragraphs
2. **Be specific:** The system prompt guides the AI's behavior
3. **Select precisely:** Only the selected text will be processed and replaced
4. **Test your provider:** Use "Test Connection" after configuring a new provider

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `⌘⌥/` | Fix selected text |
| `⌘Q` | Quit Pouf |

## Privacy

- **Ollama:** All processing happens locally. Your text never leaves your machine.
- **Gemini/Grok:** Text is sent to cloud APIs for processing. Review their privacy policies.

API keys are stored securely in the macOS Keychain.
