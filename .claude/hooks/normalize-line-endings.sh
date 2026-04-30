#!/usr/bin/env bash
# PostToolUse hook — normalizes line endings after Write/Edit.
# On Windows (OS=Windows_NT): converts LF→CRLF, skipping .sh and binary files.
# On macOS/Linux: no-op (files stay LF naturally).

# No-op on non-Windows platforms
[ "${OS}" = "Windows_NT" ] || exit 0

data=$(cat)
file_path=$(echo "$data" | python -c \
  "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" \
  2>/dev/null)

[ -z "$file_path" ] && exit 0
[ -f "$file_path" ] || exit 0

# Shell scripts must stay LF (Docker / Unix compatibility)
case "$file_path" in
  *.sh) exit 0 ;;
esac

# Skip binary files (NUL-byte heuristic)
if grep -qP '\x00' "$file_path" 2>/dev/null; then
  exit 0
fi

# Convert to CRLF: unix2dos if available, else sed fallback
if command -v unix2dos &>/dev/null; then
  unix2dos --quiet "$file_path" 2>/dev/null
else
  sed -i 's/\r//' "$file_path" && sed -i 's/$/\r/' "$file_path"
fi

exit 0
