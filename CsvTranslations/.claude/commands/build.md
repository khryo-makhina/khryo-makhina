---
description: Build the translations_csv solution and all projects
---

## Build Status

!`dotnet build translations_csv.sln`

## Test Status

!`dotnet test translations_csv.sln`

## Project Structure

The solution contains these projects:
- TranslationTools (library)
- AddEntryApp (console app)
- TextFileSplitterApp (console app)
- OllamaTranslatorApi (library)
- OllamaTranslatorApp (console app)
- TextToSpeechApp (Windows TTS app)
- TextToSpeechCore (library)
- Test projects for libraries

## Next Steps
After building, you can run individual apps with `dotnet run --project <project-path>`