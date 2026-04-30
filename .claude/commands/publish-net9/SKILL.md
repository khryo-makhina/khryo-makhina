---
name: publish-net9
description: Publish supported .NET 9 apps as self-contained Windows bundles for end-user distribution.
argument-hint: "[project names or --all]"
disable-model-invocation: true
---

Run `publish-net9-selfcontained.ps1` to produce bundled Windows executables for .NET 9 apps in this repo.

Supported project names:
- `AddEntryApp`
- `OllamaTranslatorApp`
- `TextFileSplitterApp`
- `TextToSpeechApp`

Examples:
- `publish-net9` — publish all supported apps
- `publish-net9 AddEntryApp,OllamaTranslatorApp` — publish only the selected apps

If bundle size is too large for distribution, use `install-net9-runtime.ps1` instead to install .NET 9 runtime semi-automatically on the target machine.
