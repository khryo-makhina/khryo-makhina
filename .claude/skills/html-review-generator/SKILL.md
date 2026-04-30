---
name: html-review-generator
description: Generate professional HTML review reports from structured data
argument-hint: "report title (e.g., 'Code Review: feature-branch')"
---

# html-review-generator

Generates professional HTML review reports from JSON data, saved to `temp_user_files/`.

## Input

JSON structure (via stdin or temp file):

```json
{
  "title": "Code Review: feature-branch",
  "metadata": {"Input Type": "Branch", "Date": "2026-04-29", ...},
  "sections": [
    {"title": "Summary", "content": "...", "type": "text"},
    {"title": "Code", "content": "...", "type": "code"},
    {"title": "Findings", "items": [...], "type": "list"}
  ]
}
```

Argument: Report title (for filename generation)

## Output

HTML file at `temp_user_files/YYYY-MM-DD_<sanitized-title>.html`

## Workflow

1. **Read JSON**: From stdin or `/tmp/review-data.json`
2. **Render sections**: Text, code blocks, lists, nested subsections
3. **Apply template**: Professional styling (responsive, color-coded, print-friendly)
4. **Save file**: Create `temp_user_files/` if needed, write HTML
5. **Report path**: Return relative path to user

## Template

Use built-in template with:
- Metadata table (key-value pairs)
- Sections with proper heading hierarchy
- Color-coded findings (success/error/info/warning)
- Code blocks with monospace font
- Responsive layout

For custom templates, set `HTML_REVIEW_TEMPLATE=path/to/template.html`
