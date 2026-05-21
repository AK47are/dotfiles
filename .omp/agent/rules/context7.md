---
name: context7
description: Use context7 CLI for up-to-date library documentation, API references, and code examples
alwaysApply: true
---

# Context7 — Up-to-Date Library Documentation

When the user asks about library APIs, documentation, code generation, setup/configuration, or needs code examples for external packages/frameworks/libraries:

1. **Resolve library** — run `ctx7 library <name> <query>` to find matching libraries
   - `<name>`: library name (e.g., react, nextjs, prisma, supabase, tailwind)
   - `<query>`: what the user is trying to do (e.g., "authentication with JWT", "middleware setup")
   - Pick the best matching result; note the `Context7-compatible library ID`

2. **Fetch docs** — run `ctx7 docs <libraryId> <query>` to get up-to-date documentation
   - `<libraryId>`: the `/org/project` ID from step 1
   - `<query>`: specific question about the library
   - Returns current code snippets and explanations from source repositories

3. **Use the documentation** — incorporate the returned snippets into your answer instead of relying on training data

This ensures code examples are current and APIs actually exist, especially for recently updated libraries.

## Examples

- `ctx7 library react "hooks with useEffect cleanup"`
- `ctx7 docs /reactjs/react.dev "How to clean up useEffect with async operations"`
- `ctx7 library nextjs "How to set up app router with middleware"`
- `ctx7 docs /vercel/next.js/v15.0.0 "App router authentication"`
- `ctx7 docs /prisma/prisma "Define one-to-many relations with cascade delete"`

## When to use context7

- User asks for code examples from external libraries
- User mentions a framework (React, Next.js, Express, Prisma, Supabase, Tailwind, etc.)
- User asks for API setup or configuration steps
- The library is frequently updated (newer versions differ from training data)
- You need to verify API method signatures exist

## Note

- Library IDs always start with `/` (e.g., `/facebook/react`, not `react`)
- Works best with specific queries describing what you're trying to accomplish
- Authentication is optional — runs without API key (lower rate limits)
- CLI is installed globally as `ctx7`
