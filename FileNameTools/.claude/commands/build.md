---
description: Build the FileNameTools solution and all projects
---

## Build Status

!`dotnet build FileNameTools.sln`

## Test Status

!`dotnet test FileNameTools.sln`

## Project Structure

The solution contains these projects:
- FileNameSanitizer (library for filename normalization)
- FilenameSanitizerCli (console application for batch processing)
- FilenameSanitizer.Tests (unit tests)

## Key Features
- Cross-platform filename compatibility
- Configurable replacement patterns via `sanitizer_replace_patterns.txt`
- Customizable settings via `sanitizer_settings.json`
- Batch directory processing with logging

## Usage Examples
- `FilenameSanitizerCli .` - Sanitize current directory
- `FilenameSanitizerCli C:\Files prefix-;_old` - Remove specific patterns
- Check `operation_log.txt` for audit trail

## Next Steps
After building, test the CLI with: `dotnet run --project FilenameSanitizerCli -- .`