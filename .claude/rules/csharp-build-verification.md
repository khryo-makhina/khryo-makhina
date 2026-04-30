## Always Verify Build After Modifying C# Code

After changing any `.cs`, `.csproj`, or `.sln` file the solution MUST compile before
the task is complete. A task ending with compilation errors is NOT done.

**How to verify**: Use the `/csharp-build-verify` skill — it discovers the affected
solution, checks for null-byte corruption, runs `dotnet build --no-incremental`, and
reports all errors.

**Automated gate**: A `PreToolUse` hook runs the build automatically before any
`git commit` with staged `.cs` files, blocking the commit if the build fails.

## Common Causes of Breakage

- Missing `using` directives when adding new type references
- Changed method signatures without updating every call site
- Renamed types or members without updating all usages
- Removed constructor parameters without updating all instantiation points
- Type mismatches introduced during refactoring

## MSBuild Props / Targets (MSB4011)

Never explicitly `<Import>` `Directory.Build.props` or `Directory.Build.targets`
inside a `.csproj`. The MSBuild SDK auto-imports them — an explicit import raises MSB4011.

Exception: legacy `<Project>` files without `Sdk=` do NOT receive the automatic import.

## File Corruption (MSB5010 / CS1056)

If a build reports `MSB5010` or `CS1056 (Unexpected character '\0')`, restore from git:

```bash
git show HEAD:path/to/file.cs > path/to/file.cs
```

Never edit corrupted files directly. Full detection and recovery steps are in
`/csharp-build-verify`.
