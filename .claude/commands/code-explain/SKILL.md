---
name: code-explain
description: Explain code — what it does, what's non-obvious, where to be careful
argument-hint: "[file, function, or concept]"
user-invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
---

Explain `$ARGUMENTS`.

Assume .NET/C# familiarity. Skip obvious code.

**Structure:**
- One sentence: what it does and why it exists
- Non-obvious decisions/tradeoffs
- Gotchas, edge cases, hidden dependencies  
- Risky change points and why

**Diagrams:** ASCII/Mermaid only if control/data flow isn't clear from code.

**Style:** Concise. No padding. No obvious walkthroughs.
