---
name: csharp-code-reviewer
description: Review C# code changes for quality, patterns, and project conventions
argument-hint: "file paths, diff content, or directory"
---

# csharp-code-reviewer

Analyzes C# code changes for quality, patterns, and conventions.

## Input

- File paths: Space-separated `.cs` files
- Diff content: Git diff output
- Directory: Scans for modified `.cs` files
- No argument: Uses staged files (`git diff --cached`)

## Output

Structured review with:
- **Strengths**: Positive patterns
- **Issues**: Must-fix problems
- **Suggestions**: Nice-to-have improvements
- **Convention Violations**: Rule violations with line numbers

## Review Criteria

### Naming Conventions (IDE0049)
- ✓ `String.IsNullOrEmpty(value)`, `Int32.Parse(input)`
- ✗ `string.IsNullOrEmpty(value)`, `int.Parse(input)`

### Async Methods
- ✓ `public async Task GetUser(int id)`
- ✗ `public async Task GetUserAsync(int id)` (no Async suffix)

### Test Conventions
- xUnit + Shouldly + NSubstitute (NEVER Moq)
- Given/When/Then structure with `sut` variable
- Scenario-specific helper methods (not 10+ param generic helpers)

### Anti-Patterns
- Moq usage (banned library)
- Empty try-catch blocks
- Emojis in source code
- Hard-coded secrets/connection strings

## Workflow

1. **Identify files**: From arguments or git diff
2. **Analyze each file**: Check naming, test structure, security
3. **Categorize findings**: Strengths/Issues/Suggestions/Conventions
4. **Format output**: Markdown with file:line references

## Configuration

Optional: `.csharp-reviewer.json` in repo root for ignore patterns and severity levels

JSON output: `CSHARP_REVIEWER_JSON=1`
