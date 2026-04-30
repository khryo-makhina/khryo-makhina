TextToSpeechApp

A Windows console application that uses Windows Speech API (SAPI) to speak translation entries from CSV files. The application randomly selects entries and reads them aloud in their respective languages, helping with language learning through audio repetition.

## Prerequisites

### **Required Software**
- **.NET 9 SDK** - The application targets `net9.0-windows10.0.19041.0`
- **Windows 10 or newer** (build 19041+) - Required for Windows SAPI/WinRT integration
- **64-bit Windows** - Application is compiled for `win-x64` runtime

### **System Requirements**
- Windows 10 version 19041 (May 2020 Update) or later
- Windows Speech Platform voices installed (check Windows Settings → Time & Language → Speech)
- Sufficient disk space for .NET 9 runtime

## Why Windows 10+ and .NET 9?

This application utilizes **Windows.Media.SpeechSynthesis** from the **Windows Runtime (WinRT)** API, which:
- Is only available on Windows 10 build 19041 and newer
- Requires the `net9.0-windows` target framework with `UseWinRT=true`
- Needs Windows-specific APIs for text-to-speech functionality
- Uses modern SAPI voices with better language support

## Building and Running

### **Build the application**
```powershell
cd translations_csv\TextToSpeechApp
dotnet build
```

### **Run the application**
```powershell
# Using default CSV file (translations.csv in parent directory)
dotnet run

# Specify a CSV file
dotnet run "csv_files/finnish_english_corporate_phrases.csv"

# Specify CSV file and starting line number
dotnet run "csv_files/finnish_english_technical_vocabulary.csv" 50
```

### **Publish for distribution**
```powershell
dotnet publish -c Release -r win-x64 --self-contained
```

## Command-line Arguments

```
TextToSpeechApp [path to translations CSV file] [starting line number]
```

- **CSV file path**: Optional path to a CSV file. Defaults to `translations_csv/translations.csv`
- **Starting line number**: Optional line number to start reading from (1-based index)

### **Examples**
```powershell
# Use default CSV file
dotnet run

# Use specific CSV file
dotnet run "csv_files/finnish_english_corporate_vocab.csv"

# Start from line 100
dotnet run "csv_files/misc_words_en_vi_fi.csv" 100

# Use absolute path
dotnet run "C:\path\to\your\translations.csv"
```

## CSV File Format

The application expects CSV files with the following format:
- First row contains language headers (e.g., "English", "Finnish", "Vietnamese")
- Each subsequent row contains translations in corresponding languages
- Empty cells are allowed (will be skipped during speech)

Example:
```csv
English,Finnish,Vietnamese
hello,hei,xin chào
goodbye,näkemiin,tạm biệt
```

## Features

### **Multi-language Support**
- Automatically detects languages from CSV headers
- Uses appropriate Windows SAPI voices for each language
- Falls back to system default voice if language-specific voice not available

### **Interactive Controls**
While the application is running:
- **ESC key**: Stop speech and exit application
- **ENTER key**: Pause speech for 10 seconds
- **SPACEBAR**: Pause speech (press SPACEBAR again to resume)
- **Ctrl+C**: Emergency stop (console interrupt)

### **Randomized Playback**
- Selects translation entries randomly for varied practice
- Speaks each language in a row sequentially
- Displays progress counter (e.g., "001 / 150")

## Available CSV Files

The `csv_files/` directory contains several pre-populated translation files:
- `finnish_english_corporate_phrases.csv` - Business and corporate phrases
- `finnish_english_corporate_vocab.csv` - Corporate vocabulary
- `finnish_english_technical_vocabulary.csv` - Technical terms
- `misc_words_en_vi_fi.csv` - Miscellaneous words in English, Vietnamese, Finnish
- `finnish_english_corporate_phrases_vietnamese.csv` - Trilingual corporate phrases

## Technical Details

### **Project Configuration**
```xml
<TargetFramework>net9.0-windows10.0.19041.0</TargetFramework>
<UseWinRT>true</UseWinRT>
<RuntimeIdentifier>win-x64</RuntimeIdentifier>
```

### **Dependencies**
- `TranslationTools` project (shared library for CSV parsing)
- `Microsoft.Extensions.DependencyInjection` (v10.0.3)
- Windows WinRT APIs (provided by Windows)

### **Voice Selection**
The application attempts to match CSV language headers with installed Windows voices:
1. Tries to find exact language match (e.g., "fi-FI" for Finnish)
2. Falls back to generic language match (e.g., any "fi-*" voice)
3. Uses system default voice if no match found

## Troubleshooting

### **"No translation entries found"**
- Ensure CSV file exists and is accessible
- Check CSV format (headers in first row)
- Verify file path is correct

### **"Using default voice" messages**
- Windows may not have voices installed for certain languages
- Install additional voices via Windows Settings → Time & Language → Speech
- Download language packs for missing languages

### **Build errors about WinRT**
- Ensure you have .NET 9 SDK installed
- Verify Windows 10 version 19041 or newer
- Check that `UseWinRT` property is enabled in csproj

### **Application crashes on startup**
- Run as Administrator if experiencing permission issues
- Check Windows Speech services are running
- Verify .NET 9 runtime is installed

## Example Session

```
Loading CSV entries from 'csv_files/finnish_english_corporate_phrases.csv' ...
Available voices:
- Microsoft David Desktop (en)
- Microsoft Zira Desktop (en)
- Microsoft Heera Desktop (en)
Using voice: Microsoft David Desktop for language: en
Loaded entries: 150
Starting text-to-speech for translation entries. Press Ctrl+C or ESC to stop.
Press Enter to pause for 10 seconds. Press space bar to pause and again to resume.
Reciting 150 entries, randomly.
001 / 150 :: "Good morning","Hyvää huomenta"
002 / 150 :: "Thank you for your email","Kiitos sähköpostistasi"
[ESC pressed]
Esc pressed — stopping speech. Exiting.
```

## Development Notes

- The application uses asynchronous speech synthesis to prevent blocking
- Each language has its own `SpeechSynthesizer` and `MediaPlayer` instance
- Memory is properly disposed via `IDisposable` pattern
- Console input is non-blocking (uses `Console.KeyAvailable`)

## Related Projects

- **TranslationTools** - Core library for CSV parsing and translation entry management
- **AddEntryApp** - Application for adding new entries to translation CSV files
- **OllamaTranslatorApp** - AI-powered translation using Ollama API

## License

See the parent directory `LICENSE` file for licensing information.