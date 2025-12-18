# Configurable AI Providers

## Problem
The application currently supports only a single, hard-coded AI provider (Ollama) for its rephrasing feature. This limits user choice and flexibility, tying a core feature to a single service. Users who prefer other models like Gemini or Grok, or who may get better results from them, have no option to switch. There is also no clear in-app interface for managing AI service configurations.

## Solution
This feature will introduce a flexible, multi-provider architecture for the AI-powered rephrasing functionality. A new settings panel will be created to allow users to configure and switch between multiple AI providers: the existing Ollama service, plus new integrations for Gemini and Grok. The application's rephrase logic will be updated to dynamically use the provider that the user has selected as active.

## User Impact
- **Choice and Flexibility**: Users can connect their preferred AI service (Ollama, Gemini, or Grok) based on their own accounts and preferences.
- **Improved Results**: Users can switch providers at any time to find the one that gives the best rephrasing results for their specific needs.
- **Centralized Management**: A dedicated UI for managing AI providers gives users clear control over credentials and the active service.

## Key Features
- A new settings screen for "AI Provider Configuration".
- Input fields to securely save API credentials for Gemini and Grok.
- A selector to set the active provider (Ollama, Gemini, or Grok).
- The "rephrase" feature will use the selected provider for all its operations.

## Requirements
- **UI/UX**:
    - A new view accessible from the main settings screen.
    - Secure text fields for API keys.
    - A picker or dropdown for provider selection.
- **Backend**:
    - An abstraction layer for AI clients to standardize interactions.
    - New, specific client implementations for Gemini and Grok APIs.
- **Data**:
    - A secure method (e.g., Keychain) for storing user-provided API keys.
    - A mechanism to persist the user's active provider choice.
- **Out of Scope**:
    - Integration of providers into features other than "rephrase".
    - Automatic failover between providers.
    - Support for providers other than Ollama, Gemini, and Grok.

## Dependencies
- This feature modifies the core rephrasing logic and the main application settings.
- It introduces new dependencies on secure storage (Keychain).
