---
name: rewrite-exercise
description: Backs up the original project code, then allows the user to rewrite the implementation in the original file locations, verifying understanding by comparing against the backup.
context: fork
agent: general-purpose
disable-model-invocation: true
---

## Output Structure

> **Note:** Generate this `README.md` file **last**, after completing all other files.

Directly operates on project files while preserving the original files as reference:

```
.claude/exercises/rewrite-<module-name>/
├── README.md # Explains what to delete, rewrite goals, checklist for comparison
└── backup/   # Backup of original project files
```

## Exercise Template

```markdown
## Learning Objectives

- [Specific, verifiable objectives — not "understand X" but "implement X that can do Y"]

## Prerequisites

Must explain what each prerequisite is, why it is needed, the underlying principles, and how to use it.

Also explain any further prerequisites derived from these prerequisites clearly.

## Task Description

- Original code location: [~/project/path]
- Code to delete: [function/class/line range], format: `./backup/file:line-range`
- Verification: Compare against `backup/` or run existing tests `[command]`

## Directory Structure

[List each file generated in this directory and explain what content it contains]
```
