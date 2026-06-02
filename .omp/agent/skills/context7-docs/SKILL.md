---
name: context7-docs
description: "Retrieve up-to-date documentation and code examples from Context7 for any library, framework, SDK, CLI tool, or cloud service. Use when the user asks about API usage, configuration, or examples for a specific technology."
license: MIT
---

# Context7 Documentation Lookup

Retrieve current documentation and code examples from [Context7](https://context7.com) using the `resolve-library-id` and `query-docs` tools that ship with this extension.

## When to use

Reach for these tools whenever a question involves a specific library, framework, SDK, CLI tool, or cloud service. Examples:

- "How do I configure caching in Next.js 16?"
- "What's the syntax for Prisma's `findMany` with relations?"
- "Show me a working Tailwind v4 install for a Vite app."
- "How do I rate-limit with `@upstash/ratelimit`?"

## Workflow

1. **Resolve the library ID.** Call `resolve-library-id` with the library name and the user's question. The tool returns matching libraries with their Context7 IDs (`/org/project` format), descriptions, snippet counts, and quality scores. Pick the best match — prioritize official sources, name match, and high benchmark scores.
2. **Query the docs.** Call `query-docs` with the chosen library ID and the user's question. The tool returns documentation snippets and code examples.
3. **Answer.** Cite the library ID you used and quote code examples verbatim when relevant.

If the user supplies a library ID in `/org/project` or `/org/project/version` format directly, skip step 1 and call `query-docs` immediately.

## Constraints

- Do not call either tool more than 3 times per question.
- Do not pass API keys, passwords, credentials, personal data, or proprietary code as the `query` argument — it is sent to the Context7 API.
- Authentication uses the `CONTEXT7_API_KEY` environment variable. Get a key at https://context7.com/dashboard if requests fail with an auth error.
