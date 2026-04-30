#!/bin/bash
# project-env.sh
# Helper functions for khryo-makhina project environment
# Simplified version without external API dependencies

# Get the project root from git
# Usage: PROJECT_ROOT=$(get_project_root) || exit 1
get_project_root() {
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [[ -n "${git_root}" ]] && [[ -d "${git_root}" ]]; then
        echo "${git_root}"
        return 0
    fi

    echo "ERROR: Not in a git repository" >&2
    return 1
}

# Check if we're in a specific subproject
# Usage: if is_subproject "FileNameTools"; then ...
is_subproject() {
    local subproject_name="$1"
    local current_dir
    current_dir=$(pwd)

    if [[ "${current_dir}" == *"/${subproject_name}"* ]] || [[ "${current_dir}" == *"\\${subproject_name}"* ]]; then
        return 0
    fi
    return 1
}

# Find the nearest solution file
# Usage: SLN_FILE=$(find_nearest_solution) || exit 1
find_nearest_solution() {
    local start_dir="${1:-.}"
    local search_dir="${start_dir}"

    while [[ "${search_dir}" != "." ]] && [[ "${search_dir}" != "/" ]] && [[ -n "${search_dir}" ]]; do
        local found
        found=$(find "${search_dir}" -maxdepth 1 -name "*.sln" 2>/dev/null | head -1)
        if [[ -n "${found}" ]]; then
            echo "${found}"
            return 0
        fi
        search_dir=$(dirname "${search_dir}")
    done

    # Fallback: search from current directory
    local fallback
    fallback=$(find . -name "*.sln" -not -path "*/bin/*" -not -path "*/obj/*" 2>/dev/null | head -1)
    if [[ -n "${fallback}" ]]; then
        echo "${fallback}"
        return 0
    fi

    echo "ERROR: No solution file found" >&2
    return 1
}
