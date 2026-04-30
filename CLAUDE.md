# Public Hobby Projects Repository

This repository contains multiple independent hobby projects: utilities, translation tools, filename sanitizers, and offline AI experiments.

**Platform:** Windows 11 primary development environment
**Tech Stack:** .NET 9.0, C#, Docker, PowerShell, Bash
**Nature:** Personal hobby projects maintained in spare time, not production-grade

## Repository Structure

This is a multi-project repository with subdirectories that have their own .claude configurations:

- **FileNameTools/**: Cross-platform filename sanitization utility (.NET)
  - Has own .claude config with filename-specific rules
  - Build: `cd FileNameTools; dotnet build FileNameTools.sln`

- **translations_csv/**: CSV-based translation tools and Ollama AI integration (.NET)
  - Has own .claude config with Windows-specific rules
  - Build: `cd translations_csv; dotnet build translations_csv.sln`

- **ai_offline/ollama_with_open_webui/**: Docker stack for local Ollama with WebUI
  - Has own CLAUDE.md with Docker-specific guidance
  - Run: `cd ai_offline/ollama_with_open_webui; docker compose -f docker-compose-ollama-with-open-webui.legacy.yml up -d`

- **local_dev/**: Development documentation and guides
  - Claude Code guide, TTS analysis, local tooling docs

## Common Commands

When working at repository root:
```bash
# View all solutions
find . -name "*.sln" -type f

# Git status across entire repo
git status

# Check all subdirectory CLAUDE.md files
cat FileNameTools/CLAUDE.md
cat translations_csv/CLAUDE.md
cat ai_offline/ollama_with_open_webui/CLAUDE.md
```

## Windows Development Notes

- Line endings: CRLF for .NET code, markdown, and text files (enforced via .gitattributes)
- Shell scripts: LF even on Windows (Docker compatibility)
- PowerShell preferred over CMD for scripting
- Build commands use `dotnet` CLI
- Requires .NET 9 SDK / targeting pack to build `net9.0` projects; newer SDKs may still need the net9 targeting pack installed
- Git bash environment available (Unix shell syntax)

## Project-Specific Work

When working in subdirectories (FileNameTools, translations_csv), Claude Code automatically loads their local .claude configurations and CLAUDE.md files. Root-level settings apply across all projects, subdirectory settings override for specific contexts.

## Important

- **This is a hobby repository** - maintained in spare time, not production-ready
- **No external dependencies at root** - each project is independent
- **Check subdirectory docs** - each project has its own build/run instructions
- **See @README.md** for license and contact information
