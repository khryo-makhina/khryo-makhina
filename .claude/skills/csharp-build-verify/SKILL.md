---
name: csharp-build-verify
description: >
  Verify C# code compiles cleanly before committing. Auto-discovers the affected
  solution from staged/modified files, checks for null-byte file corruption, runs
  dotnet build, and reports any compiler errors. Use before any git commit that
  touches .cs files.
---

# csharp-build-verify

You verify that staged or modified C# code compiles before it is committed.

## How to invoke

### Step 1 — Discover affected files

Run these two commands and combine the results:

```bash
git diff --staged --name-only
git diff --name-only
```

If both are empty, there is nothing to check — report "No C# changes detected" and exit.

### Step 2 — Locate affected solutions

For each changed `.cs` or `.csproj` file, walk up its directory tree to find the
nearest `.sln` file. That file is the solution to build.

```bash
# List all solutions in the repo as a reference
find . -name "*.sln" -not -path "*/bin/*" -not -path "*/obj/*"
```

Collect every unique solution that has at least one `.cs` or `.csproj` file in the
change set. If no `.cs` or `.csproj` files are present, report
"No C# changes — build check skipped" and exit.

### Step 3 — Check for file corruption

Before building, scan staged/modified `.cs` and `.sln` files for null bytes.

**macOS / Linux:**
```bash
python3 -c "import sys; sys.exit(0 if b'\x00' in open(sys.argv[1],'rb').read() else 1)" path/to/file
# exit 0 = corrupted, exit 1 = clean
```

**Windows (PowerShell)** — note: use `python`, not `python3`, on Windows:
```powershell
[System.IO.File]::ReadAllBytes('path\to\file') -contains 0
# True = corrupted, False = clean
```

If any file is corrupted:
- Restore it from git: `git show HEAD:path/to/file > path/to/file`
- Report: `Corruption detected: <path> — restored from HEAD`
- Re-scan to confirm the restored file is clean before proceeding.

### Step 4 — Build each affected solution

Run from the **repository root**:

```bash
dotnet build <solution-path> --no-incremental 2>&1
```

`--no-incremental` forces a fresh error report rather than relying on stale cached output.

Repeat for each unique solution in the set.

### Step 5 — Evaluate and report

**All solutions build clean (0 errors):**

```
Build: OK
  src/MyApp/MyApp.sln — 0 errors
```

Proceed to the next step in the calling workflow (e.g. commit).

**Any errors found:**

```
Build: FAILED
  src/MyApp/MyApp.sln — 3 error(s)

Errors:
  src/MyApp/Services/OrderService.cs(42,13): error CS0246: type 'OrderDto' not found
  src/MyApp/Controllers/OrderController.cs(17,5): error CS1002: ; expected
  src/MyApp/Data/Repository.cs(88,9): error CS0103: name 'context' does not exist

Commit aborted. Fix the errors above before committing.
```

Do NOT proceed to commit. List every error clearly so the user (or calling skill) can fix them.

## Notes

- Run from the repository root so relative solution paths resolve correctly.
- Do not run `dotnet restore` separately — `dotnet build` restores packages automatically.
- Warnings do not block the commit — only errors (lines containing `: error CS`) do.
- If the build tool itself fails (e.g., SDK not found), report that as a blocker too.
