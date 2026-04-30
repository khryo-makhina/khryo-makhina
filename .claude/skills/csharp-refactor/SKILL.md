---
name: csharp-refactor
description: Refactor C# code toward Clean Code principles — modular, readable, single-responsibility
argument-hint: "[file, function, or pattern]"
disable-model-invocation: true
---

Refactor `$ARGUMENTS`.

Assume .NET/C# familiarity. Apply Uncle Bob's Clean Code principles:
- Single Responsibility: each class/method does one thing
- Meaningful names: no abbreviations, no noise words, intent is obvious from the name
- Small functions: if it needs a comment to explain what a block does, extract it
- No duplication (DRY), but don't abstract prematurely
- Prefer modular design: low coupling, high cohesion

**Component Focus:**
- Clear interfaces/contracts between components
- Dependency injection over tight coupling
- Self-contained, independently testable components

## Process

1. Read the code and identify what smells: long methods, mixed concerns, poor names, duplication
2. State what you're changing and why — one line per change
3. Make changes in small steps; don't mix refactoring with behavior changes
4. Run `dotnet build` to verify nothing broke (run tests if they exist)

## Rules
- Don't change behavior — if you must, say so explicitly before doing it
- Don't pad with comments that restate the code
- If tests don't exist and the refactor is risky, flag it — don't silently proceed
- Don't move logic across component boundaries
