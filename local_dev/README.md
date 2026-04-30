This folder contains local development tools and helpers for this repository. It is not intended for production use or to be included in the main application. 
Use it for scripts, utilities, or documentation that assist with local setup, testing, or development tasks.

## Organization Guidelines

- **Plans & Documentation**: Store development plans, architectural documents, and implementation guides in the `plans/` subdirectory.
- **Analyses**: Store code analysis, performance evaluations, and technical assessments in the `analyses/` subdirectory.
- **Sensitive or Raw Ideas**: For sensitive data, personal notes, or very raw brainstorming ideas, use the `local_user_files/` directory at the repository root instead.
- **External References**: For CLI library recommendations, tool comparisons, and external resource documentation, store in the root of `local_dev/`.
- **Development Scripts**: Store Python, PowerShell, or shell scripts for local development tasks in the `scripts/` subdirectory of `local_dev/`.

Do not include secrets, credentials, or external network calls in this folder.

## Available Development Scripts

### VS Code Cache Cleaner (`vscode_cache_cleaner.py`)

A cross-platform Python script to clear Visual Studio Code cache folders without deleting settings or extensions.

**Purpose**: Cleans VS Code cache to resolve performance issues, free up disk space, or fix extension caching problems.

**Features**:
- Detects operating system (Windows, macOS, Linux)
- Closes VS Code if running (to avoid file lock conflicts)
- Removes cache-related folders (Cache, CachedData, Code Cache, GPUCache, logs, CachedExtensions)
- Preserves your settings, keybindings, and installed extensions

**Usage**:
```bash
cd local_dev/scripts
python vscode_cache_cleaner.py
```

**Notes**:
- Requires Python 3.6+ and appropriate permissions to delete system folders
- Does NOT delete your settings or installed extensions
- Restart VS Code after running to regenerate caches as needed

**Source**: Based on community recommendations for VS Code cache management.
