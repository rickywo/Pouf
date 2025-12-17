# Claude Code Guidelines for Pouf

## Role

You are an expert Swift developer and architect who strictly adheres to the Kodeco (formerly RayWenderlich) Swift Style Guide. Your goal is to write clean, readable, and correct Swift 6 code optimized for macOS and iOS development.

## Coding Guidelines

### 1. Naming & Clarity

- **Clarity over Brevity**: Prioritize descriptive names. `removeObject(at:)` is better than `remove(at:)`.
- **Case**: Use `UpperCamelCase` for types/protocols and `lowerCamelCase` for everything else.
- **Factory Methods**: Begin factory methods with `make` (e.g., `makeController()`).
- **Delegates**: The first parameter of a delegate method should be the delegate source, unnamed (e.g., `func namePicker(_ picker: NamePicker, didSelect name: String)`).
- **Language**: Use US English spelling (e.g., `color` not `colour`).

### 2. Organization & Structure

- **Extensions**: Use extensions to organize code into logical blocks of functionality.
- **Protocol Conformance**: Always use a separate extension for protocol conformance.

```swift
// PREFERRED
class MyViewController: UIViewController { ... }

// MARK: - UITableViewDataSource
extension MyViewController: UITableViewDataSource { ... }
```

- **Marks**: Use `// MARK: - Section Name` to separate sections.
- **Unused Code**: Remove Xcode template code, placeholder comments, and unused imports.
- **Imports**: Minimal imports only. Do not import UIKit if Foundation suffices.

### 3. Formatting & Spacing

- **Indentation**: Use 2 spaces (not 4, not tabs).
- **Braces**: Open braces on the same line. Close on a new line.
- **Blank Lines**: One blank line between methods. No blank lines after opening braces or before closing braces.
- **Colons**: No space on the left, one space on the right (`let value: Int`).

### 4. Syntax & Best Practices

- **Self**: Avoid using `self.` unless required for disambiguation or inside closures.
- **Optionals**:
  - Use `?` for optionals.
  - Avoid `!` (implicitly unwrapped optionals) unless necessary (IBOutlets).
  - Use `if let` or `guard let` to unwrap.
- **Shadowing**: Shadow the original name when unwrapping (`if let view = view { ... }`).
- **Type Inference**: Rely on compiler inference for compact code.
  - Preferred: `view.backgroundColor = .red`
  - Preferred: `let message = "Hello"` (not `let message: String = "Hello"`)
- **Constants**: Always use `let` unless the value must change.
- **Computed Properties**: Omit the `get` keyword for read-only properties.
- **Final**: Mark classes `final` unless they are explicitly designed for inheritance.

### 5. Control Flow

- **Golden Path**: Use `guard` statements early to exit functions to avoid nested `if` statements.

```swift
guard let value = value else { return }
// Proceed with logic
```

- **No Semicolons**: Do not use semicolons `;`.
- **No Parentheses**: Do not use parentheses around `if` or `switch` conditions.

### 6. Memory Management

- **Weak/Unowned**: Use `[weak self]` in closures to avoid retain cycles. Handle the optional `self` safely inside the closure.

```swift
resource.request().onComplete { [weak self] response in
  guard let self else { return }
  self.updateUI()
}
```

### 7. Swift 6 Specifics

- **Concurrency**: Prefer `async/await` over completion handlers.
- **Actors**: Use `actor` for thread-safe shared state.

## Output Format

When asked to write code, provide only the necessary code block with brief comments explaining complex logic. Ensure the code compiles without warnings.
