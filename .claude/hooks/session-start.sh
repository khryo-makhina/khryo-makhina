#!/bin/bash
# .claude/hooks/session-start.sh
# Context loader for khryo-makhina sessions

echo "=== SESSION CONTEXT ==="
echo "Date: $(date '+%A, %B %d %Y %H:%M %Z')"
echo ""

# --- Git State (fast local operations only) ---
if git rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH=$(git branch --show-current)
  echo "Branch: $BRANCH"

  echo "Last commit: $(git log -1 --pretty='%h %s (%cr)' 2>/dev/null)"
  echo ""

  # Working directory state
  STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l)
  UNSTAGED=$(git diff --name-only 2>/dev/null | wc -l)
  UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)

  if [ "$STAGED" -gt 0 ] || [ "$UNSTAGED" -gt 0 ] || [ "$UNTRACKED" -gt 0 ]; then
    echo "Working Directory:"
    [ "$STAGED" -gt 0 ] && echo "  $STAGED staged file(s)"
    [ "$UNSTAGED" -gt 0 ] && echo "  $UNSTAGED modified (unstaged)"
    [ "$UNTRACKED" -gt 0 ] && echo "  $UNTRACKED untracked file(s)"
    echo ""
  fi

  # Recent commits (context for current work)
  echo "Recent commits:"
  git log --oneline -5 2>/dev/null | sed 's/^/  /'
  echo ""
fi

# --- Project-specific reminders ---
echo "--- Project Guidelines ---"
echo "• Main branch: main"
echo "• Multi-project repository:"
echo "  - FileNameTools/ (.NET filename sanitizer)"
echo "  - translations_csv/ (.NET translation tools + Ollama)"
echo "  - ai_offline/ollama_with_open_webui/ (Docker Ollama stack)"
echo "• Check subdirectory CLAUDE.md for project-specific rules"
echo "• Testing: xUnit + NSubstitute/Shouldly"
echo ""

echo "=== SESSION CONTEXT END ==="
exit 0
