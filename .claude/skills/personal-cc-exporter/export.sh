#!/bin/bash
set -e

# Export project Claude Code config (.claude/) to target folder
# Usage: export.sh <target_folder>

PARENT_DIR="$1"

if [[ -z "$PARENT_DIR" ]]; then
    echo "ERROR: Target parent folder path required" >&2
    echo "" >&2
    echo "Usage: /personal-cc-exporter <absolute_path>" >&2
    echo "" >&2
    echo "Example: /personal-cc-exporter C:\\_myFiles" >&2
    exit 1
fi

# Find the .claude directory (from cwd or git root)
SOURCE_DIR=".claude"
if [[ ! -d "$SOURCE_DIR" ]]; then
    GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
    if [[ -n "$GIT_ROOT" && -d "$GIT_ROOT/.claude" ]]; then
        SOURCE_DIR="$GIT_ROOT/.claude"
    else
        echo "ERROR: .claude directory not found in current or git root directory" >&2
        exit 1
    fi
fi

# Convert Windows paths to Git Bash format if needed
PARENT_DIR=$(echo "$PARENT_DIR" | sed 's|\\|/|g')

# Require an absolute path
if [[ "$PARENT_DIR" != /* && ! "$PARENT_DIR" =~ ^[A-Za-z]: ]]; then
    echo "ERROR: A full (absolute) path is required — relative paths are not supported." >&2
    echo "" >&2
    echo "You provided: $1" >&2
    echo "" >&2
    echo "Example: /personal-cc-exporter C:\\_myFiles" >&2
    exit 1
fi

# Build export folder name: .claude-khryomakhina-<username>-<YYYY-MM-DD_HH-MM>
USERNAME=$(whoami | sed 's|.*[/\\+]||')
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M')
FOLDER_NAME=".claude-khryomakhina-${USERNAME}-${TIMESTAMP}"
TARGET_DIR="${PARENT_DIR}/${FOLDER_NAME}"

# Check if source exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "ERROR: Source directory not found: $SOURCE_DIR" >&2
    exit 1
fi

# Check if target is same as source
if [[ "$(realpath "$SOURCE_DIR")" == "$(realpath "$TARGET_DIR" 2>/dev/null || echo "$TARGET_DIR")" ]]; then
    echo "ERROR: Target cannot be the same as source" >&2
    echo "Source: $SOURCE_DIR" >&2
    echo "Target: $TARGET_DIR" >&2
    exit 1
fi

# Check if target exists and prompt
if [[ -d "$TARGET_DIR" ]]; then
    echo "WARNING: Target directory already exists: $TARGET_DIR" >&2
    echo -n "Overwrite? (y/N): " >&2
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Aborted by user" >&2
        exit 1
    fi
    rm -rf "$TARGET_DIR"
fi

echo "Exporting project Claude Code config..."
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"
echo ""

mkdir -p "$TARGET_DIR"

# Helper: copy folder and remove junk files
copy_folder_clean() {
    local src="$1"
    local dest="$2"
    local name="$3"
    if [[ -d "$src" ]]; then
        mkdir -p "$dest"
        cp -rp "$src/." "$dest/"
        find "$dest" \( \
            -name '.DS_Store' -o -name 'Thumbs.db' -o \
            -name '*.backup' -o -name '*.bak' -o -name '*.log' \
        \) -delete 2>/dev/null || true
        echo "  + $name"
        return 0
    fi
    return 1
}

echo "Copying config folders..."
copy_folder_clean "$SOURCE_DIR/commands" "$TARGET_DIR/commands" "commands/"
copy_folder_clean "$SOURCE_DIR/hooks"    "$TARGET_DIR/hooks"    "hooks/"
copy_folder_clean "$SOURCE_DIR/lib"      "$TARGET_DIR/lib"      "lib/"
copy_folder_clean "$SOURCE_DIR/rules"    "$TARGET_DIR/rules"    "rules/"
copy_folder_clean "$SOURCE_DIR/skills"   "$TARGET_DIR/skills"   "skills/"

# Copy scripts/statusline.js if present
if [[ -f "$SOURCE_DIR/scripts/statusline.js" ]]; then
    mkdir -p "$TARGET_DIR/scripts"
    cp -p "$SOURCE_DIR/scripts/statusline.js" "$TARGET_DIR/scripts/statusline.js"
    echo "  + scripts/statusline.js"
fi

# Copy settings.json (not settings.local.json)
if [[ -f "$SOURCE_DIR/settings.json" ]]; then
    cp -p "$SOURCE_DIR/settings.json" "$TARGET_DIR/settings.json"
    echo "  + settings.json"
else
    echo "! WARNING: settings.json not found in source"
fi

# Count files exported
FILE_COUNT=$(find "$TARGET_DIR" -type f | wc -l | tr -d ' ')
DIR_COUNT=$(find "$TARGET_DIR" -type d | wc -l | tr -d ' ')

echo ""
echo "=========================================="
echo "Export complete!"
echo "=========================================="
echo "Files: $FILE_COUNT | Directories: $DIR_COUNT"
echo ""
echo "Target: $TARGET_DIR"
echo ""
echo "Notes:"
echo "- settings.local.json was NOT copied (may contain local paths)"
echo "- Review settings.json before sharing"
echo ""
