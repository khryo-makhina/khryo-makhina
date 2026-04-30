## SQL Conventions

**Dollar Quoting**: Prefer PostgreSQL dollar quoting over escaped single quotes for better readability in Bash scripts and dynamic SQL.

**Correct**:
```sql
SELECT function_name($$15 minutes$$);
```

**Wrong**:
```sql
SELECT function_name(''15 minutes'');
```

**In Bash scripts**:
```bash
# Correct
psql -c "SELECT function_name('15 minutes');"

# Wrong — don't double single quotes at start of literals
psql -c "SELECT function_name(''15 minutes');"
```

**Unicode Characters**: Avoid bidirectional Unicode characters (emojis, RTL/LTR marks, etc.) in SQL scripts — causes warnings in pgAdmin and display inconsistencies.

**Applies to**: SQL scripts and migrations in the repository.
