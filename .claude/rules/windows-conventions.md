# Windows Development Conventions

**Platform:** Windows 11. Git Bash provides Unix shell syntax (forward slashes).

## Line Endings

| File type | Ending |
|---|---|
| `.cs`, `.csproj`, `.sln`, `.md`, `.json`, `.xml` | CRLF |
| Shell scripts (`.sh`), Docker files | LF |

Enforced via `.gitattributes`.

## Shell Commands

- Use **bash** for git, find, grep (Unix-style tools) — forward slashes, Unix paths
- Use **PowerShell** (`powershell`/`pwsh`) for Windows-specific tasks
- `dotnet` CLI works in both

## Python

Use `python` or `py` — **never `python3`**. On Windows, `python3` triggers the
Microsoft Store app alias and fails (exit code 9009).

```bash
# WRONG
python3 script.py

# CORRECT
python script.py
py script.py
```

## .NET

- Target framework: .NET 9.0
- Runtime identifier for Windows builds: `win-x64`
- Some projects use Windows-only APIs (e.g., `Windows.Media.SpeechSynthesis`)
