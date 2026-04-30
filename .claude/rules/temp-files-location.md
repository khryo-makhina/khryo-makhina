## Temp Files Location

**Path**: `temp_user_files/` (relative from project root, git-ignored)

**Naming**: `YYYY-MM-DD_descriptive-name.ext`

**Examples**:
- Bug analysis: `2026-04-16_bug_analysis.md`
- Branch review: `2026-04-16_branch_review_translations-feature.html`
- Spike: `2026-04-16_spike_batch-processing-performance.md`
- SQL test: `2026-04-16_sql-verification-test.sql`

**Rules**:
- Use relative paths, never absolute (`C:\...`)
- Use `mkdir -p temp_user_files` before writing
- Tell user: file saved to `temp_user_files/...` (git-ignored, won't commit)
