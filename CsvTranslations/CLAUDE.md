# translations_csv projects

.NET C# libraries and console apps for CSV-based translation storage. Contains tools for managing, translating, and working with translation data.

**Core Projects:**
- **TranslationTools**: Library for CSV translation file handling
- **AddEntryApp**: Console app to add English entries to translations.csv
- **TextFileSplitterApp**: Console app to split large text files with CSV formatting option
- **OllamaTranslatorApi**: Library for offline AI translation using Ollama
- **OllamaTranslatorApp**: Console app for batch CSV translation using Ollama AI translation
- **TextToSpeechApp**: Console app using Windows TTS app for reciting source texts and their translations
- **Test Projects**: Unit tests for libraries

**Data Format:** CSV with columns: Source Language, Source Text, Target Language, Target Text, Hashtags. Example: "English","word","Finnish","translation","#category"

**Key Features:** CSV-based storage, offline AI translation via Ollama, Windows TTS, batch processing, modular architecture.

**Usage:** Build with `dotnet build`, run individual apps with `dotnet run`. Requires .NET 9.0, Windows for TTS, and local Ollama instance for AI translation.

**Note:** `TextToSpeechApp` is a Windows-specific project that targets `net9.0-windows10.0.19041.0`. If `dotnet build` reports `NETSDK1127`, install the .NET 9 SDK or the .NET 9 targeting pack. A newer SDK alone does not guarantee `net9.0` build support.

## Project Dependencies

- **TranslationTools**: Core library for CSV handling
- **OllamaTranslatorApi**: Requires local Ollama instance (see `ai_offline/`)
- **TextToSpeechApp**: Windows-only (uses Windows.Media.SpeechSynthesis)
- Test projects: xUnit-based unit tests

## CSV Format

File: `translations.csv` (root of translations_csv directory)
Columns: `Source Language, Source Text, Target Language, Target Text, Hashtags`
Example: `"English","word","Finnish","translation","#category"`

## Ollama Integration

The OllamaTranslatorApi/App requires a running Ollama instance. See `../../ai_offline/ollama_integrations_claude-code.md` for setup:
- Install Ollama: https://ollama.com/download
- Pull model: `ollama pull qwen3.5:9b`
- Run translator: `dotnet run --project OllamaTranslatorApp`

## Common Tasks

- **Build all**: `dotnet build translations_csv.sln`
- **Test all**: `dotnet test translations_csv.sln`
- **Add entry**: `dotnet run --project AddEntryApp`
- **Translate batch**: `dotnet run --project OllamaTranslatorApp`
- **TTS practice**: `dotnet run --project TextToSpeechApp` (Windows only)

See `.claude/commands/build.md` for automated build/test command.

## Distribution

Use Claude Code slash commands for distribution:

- **`/publish-net9`** — Publish supported apps as self-contained `.exe` bundles
  - Creates standalone executable files with bundled .NET 9 runtime
  - Larger file sizes but no .NET 9 installation required on target machines
  - Output: `bin\Release\net9.0-windows10.0.19041.0\win-x64\publish\<app>.exe` for each project

- **`/install-net9-runtime`** — Install .NET 9 runtime on target machines
  - Semi-automatic installer for end-user deployment
  - Smaller distribution size; requires .NET 9 to be installed before running apps

These commands wrap PowerShell scripts in the repository root (`publish-net9-selfcontained.ps1` and `install-net9-runtime.ps1`).
