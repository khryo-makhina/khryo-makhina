---
name: git-commit
description: Commit staged changes (or $ARGUMENTS) using a generated commit message following Conventional Commits standard
argument-hint: "[files or path to commit, optional]"
disable-model-invocation: true
---

Commit `$ARGUMENTS`. If no argument provided, use staged changes.

**Process:**
1. **Stage files**: If `$ARGUMENTS` provided, `git add $ARGUMENTS`. Otherwise use staged changes. If nothing staged, stage logical related changes.
2. **Verify C# build**: If `.cs`/`.csproj` files changed, run `csharp-build-verifier`. Stop on build failure.
3. **Generate message**: Use `commit-message-generator` skill.
4. **Commit**: Run `git commit -m "..."` with generated message.
5. **Report**: Show commit subject line.

**Rules:**
- No amending commits
- No skipping hooks
- No committing broken C# builds
