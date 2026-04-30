## Emoji Usage

**Rule**: Only use emojis in static markdown files (.md, .htm, .html).

**Allowed**:
- README.md
- Documentation files
- HTML reports

**Forbidden**:
- Source code (.cs, .ts, .js, .py)
- PowerShell scripts (.ps1)
- SQL scripts (.sql)
- Programmatically-generated markdown
- Any content that may be parsed/executed

**Reason**: Causes encoding issues in UTF-8 with BOM files and can trigger warnings in database tools.
