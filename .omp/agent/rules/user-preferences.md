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
5. Prefer `context7-docs` over web search for library documentation. Reading skill:context7-docs whenever the user asks about a specific library, framework, SDK, CLI tool, or cloud service — including well-known ones like Next.js, Spring Boot — because your training data may not reflect recent API changes. Do not rely on your own knowledge for API details, configuration options, or version migration steps
