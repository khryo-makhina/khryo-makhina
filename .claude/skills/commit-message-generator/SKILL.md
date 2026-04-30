---
name: commit-message-generator
description: Generates commit messages following Conventional Commits standard.

## When to use
Use when user asks to write commit messages or summarize staged changes.

## Requirements
- **Subject**: <50 chars, imperative mood, no period
- **Body**: <72 chars/line, optional for non-trivial changes
- **Content**: Explain WHAT and WHY, not how
---

# commit-message-generator

Generate commit messages from staged changes using Conventional Commits.

**Process:**
1. Check `git diff --staged` (fallback to `git diff HEAD` if empty)
2. Generate immediately — no clarifying questions

**Format:**
```
type: Short description

[body — optional for non-trivial changes]
```

**Types:**
- `feat` — new feature
- `fix` — bug fix  
- `docs` — documentation only
- `refactor` — code changes (no new features/fixes)
- `test` — test changes
- `chore` — tooling/dependencies

**Rules:**
- Imperative mood: "Add feature" not "Added feature"
- Specific: avoid "updated", "changed", "modified"
- Single concern per commit
- Subject <50 chars, body <72 chars/line

**Body format for multi-file:**
```
ServiceName:
  - change one
  - change two
```
