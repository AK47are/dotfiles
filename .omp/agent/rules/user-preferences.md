---
name: user-preferences
description: Global user preferences
alwaysApply: true
---
## User Preferences

1. **Must** the `ask` tool for asking questions instead of ask directly. If you are about to assume or guess, STOP and ask instead. Every unasked question is a bug already planted in the future
2. AI-generated reports, analysis notes, and output files MUST be placed inside `.omp/` directory, NOT the project root
3. When referencing files or code locations, **must** use the `relative/path:line` format(line optional). e.g. `./test.js`, `./auth.js:42`, `./routes/user.js:15`
