---
name: usql
description: Use usql to query any database — Oracle, PostgreSQL, MySQL, and more. You must read this skill specification before using usql.
---

## Install

Check if `usql` is installed. If not, install via scoop:

```powershell
scoop install usql
```

## Connection

If you don't know the database connection string, ask the user directly and record it in `AGENTS.md`.

## Usage

```bash
usql [flags]... [DSN]
```


| Flag | Meaning | AI use |
|------|---------|--------|
| `-c "SQL"` | Run single SQL command, then exit | Default: inline queries |
| `-f file.sql` | Execute SQL file, then exit | Multi-statement or long scripts |
| `-q` | Quiet mode — suppress messages, output only | Clean output for AI parsing |
| `-o FILE` | Write output to file, not stdout | Save results for later inspection |
| `-A` | Unaligned, pipe-delimited, with headers | **Default** — compact, parseable |
| `-J` | JSON | Post-processing, nested data |
| `-F "x"` | Custom field separator (default `\|` for -A, `,` for -C) | When default delimiter conflicts |


## MUST

**Critical: SELECT-only by default.** AI agents MUST NOT execute INSERT, UPDATE, DELETE, or any DDL statements.

**Query with restraint.** Fetch only the columns and rows you need. Add `LIMIT` by default, and prefer narrow `WHERE` clauses over dumping entire tables.
