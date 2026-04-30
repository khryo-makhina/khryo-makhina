---
name: personal-cc-exporter
description: Export this project's .claude/ configuration to a target folder (sanitized for sharing)
argument-hint: 'absolute path to parent folder, e.g., C:\_myFiles'
---

# Project Claude Code Config Exporter

Exports this project's `.claude/` configuration to a target folder, sanitized for sharing.

## Usage

```
/personal-cc-exporter C:\_myFiles
```

Export folder name is generated automatically from your username and the current date/time:
```
C:\_myFiles\.claude-khryomakhina-<username>-2026-04-29_19-23
```

## What It Does

1. **Copies** from `.claude/` to target:
   - `commands/`, `hooks/`, `lib/`, `rules/`, `skills/`
   - `scripts/statusline.js`
2. **Copies** `settings.json` (review before sharing)
3. **Excludes** `settings.local.json` (may contain local paths/credentials)
4. **Removes** junk files (`.DS_Store`, `Thumbs.db`, `*.backup`, `*.bak`, `*.log`)

## Output Structure

```
<target>/
  settings.json
  commands/
  hooks/
  lib/
  rules/
  scripts/statusline.js
  skills/
```

## Error Handling

- **No argument**: Aborts with usage message
- **Target exists**: Prompts for confirmation before overwrite
- **No .claude dir**: Aborts with error
- **Target is source**: Aborts to prevent self-overwrite

## Notes

- Does NOT copy `settings.local.json`
- Recipient should review `settings.json` for any environment-specific paths
