#!/bin/bash
# .claude/hooks/session-compact.sh
# Minimal context recovery after compaction (context window reset)

echo "=== CONTEXT RECOVERY ==="

# Minimal git state (just what's needed to re-orient)
if git rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH=$(git branch --show-current)
  echo "Branch: $BRANCH"

  # Current work state
  STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l)
  UNSTAGED=$(git diff --name-only 2>/dev/null | wc -l)

  [ "$STAGED" -gt 0 ] && echo "• $STAGED file(s) staged"
  [ "$UNSTAGED" -gt 0 ] && echo "• $UNSTAGED file(s) modified"
fi

echo ""
echo "Multi-project repo: Check subdirectory CLAUDE.md for project-specific context"
echo "=== CONTEXT RECOVERY END ==="
exit 0
