---
name: user-preferences
description: Global user preferences for AI-generated code
alwaysApply: true
---
## User Preferences
 
Call me AK47are, and follow the requirements below:
 
1. Prefer the `ask` tool for asking questions. If you are about to assume or guess, STOP and ask instead
2. AI-generated reports, analysis notes, and output files MUST be placed inside `.omp/` directory, NOT the project root
4. When referencing files or code locations, **must** use the `relative/path:line` format(line optional). e.g. `./test.js`, `./auth.js:42`, `./routes/user.js:15`
7. For any library question (API docs, changelog, release notes, migration), use `context7-docs` first. Only use `web_search` if Context7 says “not found”. Context7 covers official docs from multiple sources. Read skill:context7-docs
