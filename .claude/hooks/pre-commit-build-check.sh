#!/usr/bin/env bash
# PreToolUse hook — auto-verifies dotnet build before any "git commit" bash call.
# Blocks the commit (exit 2) if C# files are staged and the build fails.
# Exits 0 immediately for all non-commit bash commands.

data=$(cat)
cmd=$(echo "$data" | python -c \
  "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" \
  2>/dev/null)

# Only act on git commit commands
case "$cmd" in
  "git commit"*) ;;
  *) exit 0 ;;
esac

# Check if any C# files are staged
cs=$(git diff --staged --name-only 2>/dev/null | grep -E '\.(cs|csproj)$')
[ -z "$cs" ] && exit 0

# Walk up from first changed file to find nearest .sln
first_file=$(echo "$cs" | head -1)
sln_dir=$(dirname "$first_file")
sln=""
while [ "$sln_dir" != "." ] && [ "$sln_dir" != "/" ]; do
  found=$(find "$sln_dir" -maxdepth 1 -name "*.sln" 2>/dev/null | head -1)
  if [ -n "$found" ]; then
    sln="$found"
    break
  fi
  sln_dir=$(dirname "$sln_dir")
done

# Fallback: search from repo root
if [ -z "$sln" ]; then
  sln=$(find . -name "*.sln" -not -path "*/bin/*" -not -path "*/obj/*" 2>/dev/null | head -1)
fi

[ -z "$sln" ] && exit 0

echo "[pre-commit] C# files staged — verifying build ($sln)" >&2
dotnet build "$sln" --no-incremental --verbosity quiet >&2 2>&1
rc=$?

# Retry once on transient file-lock errors (Windows Defender, dotnet host)
if [ $rc -ne 0 ]; then
  if dotnet build "$sln" --no-incremental --verbosity quiet >&2 2>&1; then
    rc=0
  fi
fi

if [ $rc -ne 0 ]; then
  echo "" >&2
  echo "Build FAILED — commit blocked. Fix the errors above, then retry." >&2
  exit 2
fi

echo "Build OK — proceeding with commit." >&2
exit 0
