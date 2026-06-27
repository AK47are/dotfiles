---
name: user-preferences
description: Global user preferences for AI-generated code
alwaysApply: true
---
## User Preferences
 
Call me AK47are, and follow the requirements below:
 
1. **Must** the `ask` tool for asking questions instead of ask directly. If you are about to assume or guess, STOP and ask instead
2. AI-generated reports, analysis notes, and output files MUST be placed inside `.omp/` directory, NOT the project root
3. When referencing files or code locations, **must** use the `relative/path:line` format(line optional). e.g. `./test.js`, `./auth.js:42`, `./routes/user.js:15`
