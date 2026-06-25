---
name: context7-doc
description: "Retrieve up-to-date documentation and code examples from Context7 for any library, framework, SDK, CLI tool, or cloud service. Use when the user asks about API usage, configuration, or examples for a specific technology."
---

## Context7

Retrieve current documentation and code examples from [Context7](https://context7.com) using the `resolve-library-id` and `query-docs` tools that ship with this extension.

## Workflow

1. **Resolve the library ID**: Call `resolve-library-id` with the library name and the user's question. The tool returns matching libraries with their Context7 IDs (`/org/project` format), descriptions, snippet counts, and quality scores. Pick the best match — prioritize official sources, name match, and high benchmark scores.
2. **Query the docs.**: Call `query-docs` with the chosen library ID and the user's question. The tool returns documentation snippets and code examples.
3. **Answer.**: Cite the library ID you used and quote code examples verbatim when relevant.

If the user supplies a library ID in `/org/project` or `/org/project/version` format directly, skip step 1 and call `query-docs` immediately.

## Library selection guidelines

When `resolve-library-id` returns multiple matches, select the best one using these criteria in order:

- **Exact name match**: Prefer libraries whose title matches the user’s library name exactly.
- **Official source**: Prioritize results where the library ID or source indicates an official or highly trusted origin (e.g., `/vercel/next.js` over community forks).
- **Description relevance**: The description should align with the user’s intent (e.g., if they ask about React hooks, prefer a React library over a utility library).
- **Code snippet count**: Higher counts generally indicate better documentation coverage.
- **Source reputation**: `High` > `Medium` > `Low`. Avoid `Unknown` unless no other match exists.
- **Benchmark score**: Higher is better, but this is a tiebreaker after the above.

**Handling multiple good matches**: If two or more libraries are equally relevant, acknowledge this briefly but proceed with the most authoritative one. You may mention that alternatives exist.

**No good match found**: If no library matches the user’s request well, state clearly that you could not find a suitable library. Suggest refining the library name (e.g., use “Next.js” instead of “nextjs”, or check for typos).

**Ambiguous queries**: If the user asks about a generic term like “auth” or “hooks” without naming a library, ask for clarification before calling `resolve-library-id`. Do not guess.

## Version handling

If the user specifies a version (e.g., “Next.js 14”), look for a version entry in the search result. If the result includes a `versions` array, use `/org/project/version` as the library ID when calling `query-docs`. If no version is listed, use the default `/org/project`.

## Constraints

- Do not call either tool more than 5 times per question. If unresolved, ask the user
- Do not pass API keys, passwords, credentials, personal data, or proprietary code as the `query` argument — it is sent to the Context7 API
- Authentication uses the `CONTEXT7_API_KEY` environment variable. Get a key at https://context7.com/dashboard if requests fail with an auth error

## Error handling

When a tool returns an error, interpret the status code as follows:

| Status | Meaning | Action |
|--------|---------|--------|
| 401 | Invalid API key | Tell the user to check their key (must start with `ctx7sk`). |
| 404 | Library not found | The library ID does not exist. Re‑run `resolve-library-id` with a corrected library name. |
| 429 | Rate limited / quota exceeded | If no API key exists, suggest creating a free key. If a key exists, suggest upgrading at https://context7.com/plans. |
| Other 4xx/5xx | Generic failure | Retry once after a short delay. If still failing, report the error verbatim. |

If `query-docs` returns an empty string or a message about documentation not finalized, inform the user that Context7 does not yet have documentation for that library version. Suggest using a different version or checking the official docs directly.

## Response format for `resolve-library-id`

When you have selected a library, present it clearly:

- Return the selected library ID in a clearly marked section (e.g., `**Selected library ID:** /vercel/next.js`)
- Provide a brief explanation for why this library was chosen
- If multiple good matches exist, acknowledge this but proceed with the most relevant one
- If no good matches exist, clearly state this and suggest query refinements
