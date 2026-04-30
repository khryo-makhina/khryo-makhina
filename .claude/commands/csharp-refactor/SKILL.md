---
name: csharp-refactor
description: Refactor C# code toward Clean Code principles — modular, readable, single-responsibility
argument-hint: "[file, function, or pattern]"
user-invocable: true
allowed-tools:
  - Read
  - Edit
  - Write
  - Bash
  - Glob
  - Grep
---

Refactor `$ARGUMENTS`.

**Principles:**
- Single Responsibility: one thing per class/method
- Meaningful names: no abbreviations, obvious intent
- Small functions: extract if needs comment
- DRY but don't over-abstract
- Low coupling, high cohesion

**Component Focus:**
- Clear interfaces/contracts between components
- Dependency injection over tight coupling
- Self-contained, independently testable components

**Process:**
1. Identify smells: long methods, mixed concerns, poor names, duplication
2. State changes: one line per change with why
3. Small steps; no behavior changes without explicit approval
4. `dotnet build` verify; run tests if exist

**Rules:**
- No behavior changes without explicit approval
- No redundant comments
- Flag risky refactors without tests
- Don't move logic across component boundaries
