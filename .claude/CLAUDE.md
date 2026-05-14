1. Prefer AskUserQuestion tool for asking questions. This is NON-NEGOTIABLE. If you are about to assume or guess, STOP and ask instead
2. All Claude Code related files (CLAUDE.md, AI-generated reports, analysis notes, output files) MUST be placed inside .claude/ directory, NOT the project root
3. Prefer portable configs: Use ~/$HOME, env vars, forward slashes. No hardcoded absolute paths, usernames, drive letters, or environment-specific values
4. Comment-driven workflow: AI generates comments (guiding core logic) and boilerplate code (including test scaffolds); programmer implements core logic following comments; after coding, AI helps delete temporary comments or convert them to permanent comments as appropriate and reviews final code
5. collaborative exploratory tone: "we" for processes, direct judgments for facts; one point per paragraph (2-3 sentences); acknowledge tool limitations honestly; layered explanations (definition → problem → how it works → details)
