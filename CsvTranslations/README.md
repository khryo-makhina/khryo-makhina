This repository contains apps and tools to be developed as I myself or my friends need them in their daily life.

## Windows Console Apps

- `AddEntryApp` - for entering English words into file `translations.csv`
- `TextFileSplitterApp` - split large text files into smaller files
- `OllamaTranslatorApp` - translate from English to Finnish with offline AI
- `TextToSpeechApp` - read `translations.csv` using the Windows SAPI speech synthesis

## Distribution

The apps are built with .NET 9. Use Claude Code slash commands for distribution:

- `/publish-net9` — Publish all supported apps as self-contained Windows bundles (`.exe` files with bundled .NET 9 runtime)
- `/install-net9-runtime` — Install the .NET 9 runtime on target machines (for lighter-weight distribution)

Published `.exe` files will be available in `bin\Release\net9.0-windows10.0.19041.0\win-x64\publish` for each app.

## Other Utilities

- `FileNameSanitizer` - for sanitizing the file names that are downloaded from Internet or unpacked from a .zip files 