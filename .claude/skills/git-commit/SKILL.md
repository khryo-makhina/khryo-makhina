---
name: git-commit
description: Commit staged changes (or $ARGUMENTS) using a generated Conventional Commits message
argument-hint: "[files or path to commit, optional]"
disable-model-invocation: true
---

Commit `$ARGUMENTS`. If no argument provided, use staged changes.

## Process

1. **Determine what to commit**
   - If `$ARGUMENTS` provided: stage those files (`git add $ARGUMENTS`)
   - Otherwise: use whatever is already staged (`git diff --staged`)
   - If nothing staged: run `git status`, review unstaged/untracked changes, and use judgment — stage everything that looks like part of the same logical change (`git add` the relevant files), then proceed. Only ask if the changes are genuinely ambiguous or unrelated.

2. **Verify C# build (if applicable)**
   Check whether any `.cs` or `.csproj` files are in the change set (`git diff --staged --name-only`).
   If yes, run the `csharp-build-verify` skill before continuing.
   - If it reports **Build: OK** → proceed to step 3.
   - If it reports **Build: FAILED** → stop, show the errors, do NOT commit. Ask the user to fix them first.

3. **Generate the commit message**
   Use the `git-commit-message-writer` skill to produce the message. Take the primary output (the commit message block itself) — ignore any trailing notes or assumptions it appends.

4. **Commit**
   Run `git commit -m "..."` with the generated message. Use a heredoc if the message has a body.

5. **Report**
   Show the one-line subject of the commit that was created. Nothing more.

## Rules
- Never amend an existing commit
- Never skip hooks (`--no-verify`)
- Never commit when the C# build is broken
