---
paths:
  - "**/*.cs"
  - "**/*.csproj"
  - "**/*.sln"
---

# Windows Development Rules for translations_csv

## Operating System
- This project targets Windows 11/Windows 10
- Some components (TextToSpeechApp) require Windows-specific APIs
- Use Windows-compatible paths (backslashes, drive letters)

## .NET Development
- Target framework: .NET 9.0
- Windows-specific projects use `net9.0-windows10.0.19041.0`
- Use `win-x64` runtime identifier for Windows-specific builds
- Build commands: `dotnet build`, `dotnet run`, `dotnet test`

## Windows-Specific Components
- TextToSpeechApp uses Windows Media APIs (Windows.Media.SpeechSynthesis)
- Windows SAPI TTS service is Windows-only
- Some projects have `#if WINDOWS` preprocessor directives

## File Paths
- Use Windows-style paths: `C:\Users\...` or relative paths with backslashes
- Be aware of case-insensitive file system on Windows
- CSV files use comma separation with quoted strings

## Shell Commands
- Prefer PowerShell over CMD when possible
- Use `powershell` or `pwsh` for PowerShell commands
- For file operations, use Windows-compatible commands: `dir`, `copy`, `move`, `del`

## Testing
- Unit tests use xUnit
- Run tests with `dotnet test`
- Some tests may require Windows-specific environment