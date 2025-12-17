# Pouf User Guide

Pouf is a macOS menu bar app that provides system-wide AI text enhancement. Select any text and instantly improve it using a local AI.

## Prerequisites

### 1. Install Ollama

Pouf requires [Ollama](https://ollama.ai) running locally to process text.

```bash
# Install Ollama (if not already installed)
brew install ollama

# Start Ollama service
ollama serve

# Pull a model (recommended: llama3 or mistral)
ollama pull llama3
```

Verify Ollama is running by visiting: http://localhost:11434

### 2. Grant Permissions

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

### AI Tab
- **Ollama URL:** Default is `http://localhost:11434`
- **Model:** The Ollama model to use (e.g., `llama3`, `mistral`, `codellama`)
- **System Prompt:** Customize how the AI processes your text

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
- Check that Ollama is running (`ollama serve`)
- Verify the model is downloaded (`ollama list`)
- Test connection in Settings > AI > "Test Connection"

### Slow response
- Try a smaller/faster model like `mistral` or `phi`
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

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `⌘⌥/` | Fix selected text |
| `⌘Q` | Quit Pouf |

## Privacy

Pouf is completely private:
- All AI processing happens locally via Ollama
- No data is sent to external servers
- Your text never leaves your machine
