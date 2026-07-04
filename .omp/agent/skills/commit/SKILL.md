---
name: commit
description: Create git commits with automatically generated messages. Groups unrelated changes into separate commits when appropriate. Read this skill first before committing.
---

Run the following command and analyze the diff to determine how to group the changes into commits:

```bash
git status && git diff HEAD && git log -10 --format="%h %s %n%b"
```

Each commit should represent exactly one logical change — a single bug fix, feature, or refactor. Never dump unrelated changes into one commit or split a single logical change across multiple.

## Commit

Use the following command to stage files and review what will be committed:

```bash
git add <file1> <file2> ... && git diff --cached
```

Then commit the changes. The commit message should follow the repo's existing style (Conventional Commits by default).

### Message

A commit must be self-contained. The message has three parts:

- Header: *where* and *what*. Lets scanners quickly judge relevance, Prefer conciseness over detail; additional context can go in the body. Max 50 characters
- Body: *why*: explains why (context, reasoning, tradeoffs) and provides a high-level concise summary of the changes. **Do not repeat** what the code already shows
- Code: *how* (the implementation)

Together, they form a complete picture without redundancy.
