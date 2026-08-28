---
name: user-preferences
description: Global user preferences
alwaysApply: true
---
## User Preferences

1. **Must** the `ask` tool for asking questions instead of ask directly. If you are about to assume or guess, STOP and ask instead. Every unasked question is a bug already planted in the future
2. AI-generated reports, analysis notes, and output files MUST be placed inside `.omp/` directory, NOT the project root
3. Separate Chinese and English in filenames with a space
4. Any mention of a **code** file location **MUST** use `project/root/relative/path:line` (full path relative to project root, line optional), whether explicit or descriptive. Examples: `src/utils/helpers.js`, `routes/user.js:15`. Every time you cut corners, the user has to memorize the paths and dig through folders
5. Never use dashes of any kind, anywhere
6. `$HOME` defaults to empty in the `bash` tool; set it via the tool's `env` field before using `$HOME`
7. Prefer using the mathematical symbol `⇒` as arrows instead of `->` or `→`.
8. Code comments must be self-contained, from the maintainer's perspective: explain what and why (API semantics, fallback reasons, edge cases)
