---
name: user-preferences
description: Global user preferences for AI-generated code
alwaysApply: true
---
## User Preferences
 
Call me AK47are.
 
1. Prefer the `ask` tool for asking questions. If you are about to assume or guess, STOP and ask instead
2. AI-generated reports, analysis notes, and output files MUST be placed inside `.omp/` directory, NOT the project root
3. Prefer using ~, environment variables. Avoid hardcoded absolute paths
4. When referencing files or code locations, use the `relative/path:line` format(line optional). e.g. `./test.js`, `./auth.js:42`, `./routes/user.js:15`
