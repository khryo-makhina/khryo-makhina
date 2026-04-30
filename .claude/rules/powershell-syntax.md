# PowerShell Syntax: Use `;` not `&&`

Windows PowerShell 5.1 does not support `&&` (added only in PowerShell 7). Using it
produces: `The token '&&' is not a valid statement separator in this version.`

**Use semicolons to chain commands:**

```powershell
# WRONG — fails in Windows PowerShell 5.1
cd "C:\path\to\project" && dotnet build MyApp.sln

# CORRECT
cd "C:\path\to\project"; dotnet build MyApp.sln
```

When a second command must only run if the first succeeded, check `$?`:

```powershell
cd "C:\path\to\project"
if ($?) { dotnet build MyApp.sln }
```

Note: Git Bash (Unix) does support `&&` — this restriction applies only to PowerShell.
