---
paths:
  - "**/*.cs"
  - "**/*.csproj"
  - "**/*.sln"
  - "**/sanitizer_*.txt"
  - "**/sanitizer_*.json"
---

# Filename Sanitization Rules for FileNameTools

## Project Purpose
- Cross-platform filename compatibility (Windows, Linux, macOS)
- Remove invalid characters from filenames
- Configurable replacement patterns
- Batch processing of directories

## Operating System Considerations
- Windows: Invalid characters: `<>:"/\|?*`
- Linux/macOS: Invalid characters: `/` and null byte
- Case sensitivity: Windows is case-insensitive, Linux/macOS are case-sensitive
- Path separators: Windows uses `\`, others use `/`

## Configuration Files
- `sanitizer_replace_patterns.txt`: Semicolon-separated patterns to remove
- `sanitizer_settings.json`: Customizable settings for the sanitizer
- Patterns format: `prefix-;` or `_old` (removes from end)

## .NET Development
- Target framework: .NET 9.0
- Build commands: `dotnet build`, `dotnet run`, `dotnet test`
- Console app: `FilenameSanitizerCli`

## Usage Examples
- `FilenameSanitizerCli .` - Sanitize current directory
- `FilenameSanitizerCli C:\Files prefix-;_old` - Remove patterns "prefix-" and "_old"
- Batch processing with logging to `operation_log.txt`

## File Operations
- Use caution with file renaming operations
- Always test with dry-run or backup first
- Log operations for audit trail
