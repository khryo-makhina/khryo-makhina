---
name: git-commit-message-writer
description: Generates structured commit messages following the Conventional Commits standard.

## When to use this skill
Use this skill when the user asks to:
- "write a commit message"
- "GIT commit" 
- "commit my changes"
- "summarize my staged diff"
- "what should my commit say"
- Any request to describe or document staged changes for version control

## Key requirements
1. **Subject line**: Under 50 characters, summarize WHAT the commit changes (not how or why)
2. **Body lines**: Under 72 characters per line for terminal readability
3. **Content**: Explain the purpose, WHY the change was made (not how), relevant context, and any side effects
---

# git-commit-message-writer

You generate structured commit messages from staged git changes following Conventional Commits standard.

## How to invoke this skill

1. **Check for staged changes**: Run `git diff --staged` to read the staged changes
2. **If nothing staged**: Automatically fall back to `git diff HEAD` to read all modified
   tracked files — do not ask the user to stage anything first
3. **If still nothing**: Check `git status` for untracked files; if found, inform the user
   those need `git add` since they have no diff to read
4. **Generate immediately**: Do not ask clarifying questions before producing the commit message
5. **Make assumptions if needed**: If scope or type is unclear, make reasonable assumptions
   and note them after the output

## Output format

```
type(scope): short description

[body — optional, include if changes are non-trivial]

[footer — optional]
```

### Type (required)
Choose exactly one:
- `feat` — a new feature
- `fix` — a bug fix
- `docs` — documentation changes only
- `refactor` — code change that neither fixes a bug nor adds a feature
- `test` — adding or updating tests
- `chore` — build process, tooling, or dependency updates

### Scope (optional)
The module, file, or area affected. Use directory name or component name.
- **Include**: When change affects a specific module/component
- **Omit**: When change spans the entire codebase or is too broad

### Short description (required)
- **Character limit**: Under 50 characters (Conventional Commits standard)
- **Mood**: Imperative ("Add feature" not "Added feature" or "Adds feature")
- **Punctuation**: No period at the end
- **Content**: Summarize WHAT changed, not how or why

### Body (optional)
Include when changes are non-trivial or need explanation:
- **Line length**: Under 72 characters per line for terminal readability
- **Content**: Explain WHAT changed and WHY, not how
- **Skip**: If short description is self-explanatory

#### Grouping format
When changes span multiple components or files, group bullets by logical component:

```
ComponentName:
  - change one
  - change two

OtherComponent:
  - change three
```

- Use the component/module name as the group heading (no `#`, no bold)
- Indent bullets two spaces under each heading
- Omit grouping for single-component commits — use flat bullets instead

### Footer (optional)
Include only when needed:
- `BREAKING CHANGE:` if the commit breaks backward compatibility
- Reference to issue/ticket numbers if applicable

## Quality rules

### Writing style
- **Be specific**: Never use "updated", "changed", or "modified" in the short description
- **Avoid vagueness**: Never write "various improvements" or "misc fixes" — name what improved
- **Imperative mood**: Use "Add feature" not "Added feature" or "Adds feature"

### Commit scope
- **Single concern**: Each commit should address one logical change
- **Split if needed**: If more than three files changed across unrelated concerns, flag it:
  "These changes may be better split into separate commits: [list concerns]"

### Validation
- **Character count**: The short description must be under 50 characters — count before outputting
- **Line length**: Body lines must be under 72 characters for terminal readability

## Examples

### Example 1: New feature
**Input**: Staged changes adding a rate limiter to an API endpoint
**Output**:
```
feat(api): add rate limiting to /query endpoint

- Limits requests to 100 per minute per IP
- Returns 429 with Retry-After header when limit is exceeded
- Adds rate limit config to environment variables
```

### Example 2: Bug fix
**Input**: Staged changes fixing a null reference exception in user authentication
**Output**:
```
fix(auth): handle null user in authentication middleware

- Add null check before accessing user properties
- Return 401 instead of 500 when user is null
- Update tests to cover null user scenario
```

### Example 3: Documentation update
**Input**: Staged changes updating README with installation instructions
**Output**:
```
docs: update README with installation steps

- Add step-by-step installation guide
- Include environment variable configuration
- Add troubleshooting section for common issues
```

### Example 4: Refactoring
**Input**: Staged changes extracting duplicate validation logic into shared function
**Output**:
```
refactor(validation): extract duplicate validation logic

- Create shared validateEmail function
- Replace duplicate validation in UserService and AuthService
- Update tests to use shared validation function
```

### Example 5: Multi-component fix (grouped body)
**Input**: Staged changes fixing null-byte detection and solution discovery in csharp-build-verify skill
**Output**:
```
fix(csharp-build-verify): fix null-byte detection and sln discovery

SKILL.md:
  - Document null-byte corruption recovery with git show

pre-commit-build-check.sh:
  - Walk up directory tree from first changed file to find nearest .sln
  - Add retry on transient file-lock errors (Windows Defender)
```

### Example 6: Breaking change
**Input**: Staged changes removing deprecated API endpoint
**Output**:
```
feat(api): remove deprecated /v1/users endpoint

- Remove endpoint and associated handlers
- Update API documentation
- Add migration guide for clients

BREAKING CHANGE: /v1/users endpoint removed, use /v2/users instead
```
