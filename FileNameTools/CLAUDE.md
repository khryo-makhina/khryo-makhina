# FileNameTools projects

.NET C# tools for sanitizing filenames to ensure OS compatibility. Contains libraries and console apps for batch filename normalization.

**Core Projects:**
- **FileNameSanitizer**: Library for filename normalization and sanitization
- **FilenameSanitizerCli**: Console application for batch filename processing
- **FilenameSanitizer.Tests**: Unit tests for the library

**Key Features:**
- Removes invalid characters from filenames for cross-platform compatibility
- Configurable replacement patterns via `sanitizer_replace_patterns.txt`
- Customizable settings via `sanitizer_settings.json`
- Batch processing of entire directories
- Pattern-based filename cleaning with semicolon-separated patterns
- Comprehensive logging with operation logs

**Usage:** `FilenameSanitizerCli <folder> [patterns]` - Sanitize filenames in specified folder, optionally removing patterns. Example: `FilenameSanitizerCli .` or `FilenameSanitizerCli C:\Files prefix-;_old`

**Purpose:** Ensures filenames are compatible across Windows, Linux, and macOS by removing/resolving problematic characters and patterns.

## Windows Compatibility

This project is designed for cross-platform use but developed primarily on Windows 11. The sanitizer removes characters invalid on Windows (`<>:"/\|?*`) which are also problematic on other platforms.

## Configuration Files

- `sanitizer_replace_patterns.txt`: Semicolon-separated patterns (e.g., `prefix-;_old`)
- `sanitizer_settings.json`: Runtime configuration
- `operation_log.txt`: Auto-generated audit trail

## Common Tasks

- **Build**: `dotnet build FileNameTools.sln`
- **Test**: `dotnet test FileNameTools.sln`
- **Run CLI**: `dotnet run --project FilenameSanitizerCli -- <folder> [patterns]`
- **Example**: `dotnet run --project FilenameSanitizerCli -- . prefix-;_old`

See `.claude/commands/build.md` for automated build/test command.
