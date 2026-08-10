---
name: grilling
description: Interview-first when requirements are vague. MUST read this skill to resolve ambiguity, explore design branches, and align on direction before touching code.
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Use the `ask` tool to ask one question at a time. Wait for the user's response before proceeding to the next. Never ask multiple questions at once—it overwhelms the user.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
