# Repository Structure Rules

This repository may contain one or more independent projects. Each subdirectory can
have its own `.claude/` configuration and `CLAUDE.md` that override root settings.

## Discovering the project layout

Before starting work, locate all `CLAUDE.md` files to understand the repository shape:

```bash
find . -name "CLAUDE.md" -not -path "*/bin/*" -not -path "*/obj/*"
```

Read the root `CLAUDE.md` first, then the subdirectory `CLAUDE.md` for the area
you are working in. Local settings take precedence over root settings.

## Multi-project repositories

When a repo contains more than one project under separate subdirectories:

- Each subdirectory with a `.sln` or a standalone build file is an independent project.
- Discover all solutions: `find . -name "*.sln" -not -path "*/bin/*" -not -path "*/obj/*"`
- Build only the solution(s) affected by the current change — do not build the entire
  repo unless the task explicitly requires it.
- Check for subdirectory `.claude/settings.json` files that may restrict or extend
  the root permissions.

## Working in a subdirectory

1. Read the subdirectory's `CLAUDE.md` for build commands, conventions, and context.
2. Run build and test commands from that subdirectory's root, or from the repo root
   using the relative path to the solution file.
3. Do not assume the root-level build command covers all subdirectories.
