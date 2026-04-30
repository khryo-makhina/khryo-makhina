---
name: issue-investigate
description: 'Investigate a bug or unexpected behavior — analyze code, trace root cause, and save a structured analysis report to temp_user_files.'
argument-hint: '[ticket ID, file, function, error message, or description of the issue] (optional)'
user-invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
  - Agent
---

# Bug / Issue Investigator

You are investigating a bug or unexpected behavior.

## Input Detection

If `$ARGUMENTS` is empty or blank, use **Mode C** below. Otherwise detect the mode by inspecting the argument:

- **Mode A — Ticket ID**: Input matches `[A-Z]+-[0-9]+` (e.g., `REV-33992`).
  - Use the ticket ID as a slug for the output filename.
  - Search the codebase for any related code using the ticket ID.
- **Mode B — Code Reference or Description**: Input is a file path, function name, error message, or free-form description of the issue.
  - Use this content directly. Derive a short kebab-case slug for the filename (e.g., `batch-consumer-timeout`).
- **Mode C — No Arguments**: No input was provided.
  - Infer context from the current git branch name and recent git history.
  - Extract a ticket ID from the branch name if it matches `[A-Z]+-[0-9]+` (e.g., `fix/REV-33992_some_description` yields `REV-33992`). If found, proceed as Mode A.
  - If no ticket ID found, check `git diff` and `git log --oneline -10`, then ask the user what issue to investigate.

## Investigation Workflow

### Stage 1: Context Gathering

Use the Agent tool to run parallel research subagents:
- **Code search**: Find the relevant code paths, entry points, and related files. Trace the execution flow from trigger to outcome.
- **Test search**: Find existing tests covering this area. Note gaps in test coverage.
- **Git history**: Check recent changes to the affected files (`git log --oneline -20 -- <files>`). Identify potentially breaking commits.

### Stage 2: Deep Analysis

Apply the `/code-explain` lens — skip what's obvious, focus on friction:

1. **Root Cause Analysis**
   - Trace the bug from symptom to source
   - Identify the exact code path that produces the unexpected behavior
   - Note any non-obvious decisions, hidden dependencies, or implicit assumptions in the affected code

2. **Impact Assessment**
   - Which other code paths or features share the affected code?
   - Could the same root cause manifest elsewhere?
   - What is the blast radius of a fix?

3. **Risk Areas**
   - Where are changes risky and why?
   - Are there concurrency, timing, or state management concerns?
   - Edge cases that could complicate a fix

### Stage 3: Report Generation

**Determine the output filename:**
- Mode A: `YYYY-MM-DD_<TICKET-KEY>_bug_analysis.md` (e.g., `2026-04-16_REV-33992_bug_analysis.md`)
- Mode B: `YYYY-MM-DD_<slug>_bug_analysis.md` (e.g., `2026-04-16_batch-consumer-timeout_bug_analysis.md`)
- Mode C (with ticket from branch): same as Mode A

**Create the directory if it doesn't exist:**
```bash
mkdir -p temp_user_files
```

**Write the report** to `temp_user_files/<filename>` using this structure:

```markdown
# Bug Analysis: <Title>

**Reference**: <ticket ID or N/A>
**Date**: <YYYY-MM-DD>
**Investigated by**: Claude (AI-assisted)

## Summary

<1-3 sentences: what the bug is and why it happens>

## Root Cause

<Precise explanation of the root cause with file paths and line references>

## Affected Code

| File | Lines | Role |
|------|-------|------|
| <path> | <range> | <what it does in this context> |

## Execution Flow

<ASCII diagram of the relevant control/data flow — only if the flow isn't obvious>

## Impact & Blast Radius

<What else is affected, shared code paths, downstream consumers>

## Risk Areas

<Where changes are risky, concurrency concerns, edge cases>

## Suggested Fix

<Concrete recommended approach — what to change and why>
<Alternative approaches if applicable, with tradeoffs>

## Related

- <Links to related tickets, PRs, or documentation if found>
- <Recent commits that may be relevant>
```

### Stage 4: Summary

After writing the file, report to the user:
1. The file path where the report was saved
2. A 2-3 sentence summary of findings
3. The suggested fix approach
4. Remind the user: this file is in `temp_user_files` and won't be committed

## Guidelines

- Be concise. No padding, no walkthrough of obvious lines.
- Assume .NET/C# familiarity.
- Include file paths and line numbers for all code references.
- If you cannot determine the root cause with confidence, say so and list what you'd need to confirm.
- Do NOT make code changes — this skill is analysis only.
