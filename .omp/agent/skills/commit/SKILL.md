---
name: commit
description: Create git commits with automatically generated messages. Groups unrelated changes into separate commits when appropriate. Read this skill first before committing.
---

Run the following command and analyze the diff to determine how to group the changes into commits:

```bash
git status && git diff HEAD && git log -10 --format="%h %s %n%b"
```

> If the diff alone does not provide enough context to write a high-quality message, run the `/grilling` skill to interact with the user and gather the necessary information. Never fabricate. This prevents back-and-forth corrections later.

Each commit should represent exactly one logical change — a single bug fix, feature, or refactor. Never dump unrelated changes into one commit or split a single logical change across multiple.

## Commit

Use the following command to stage files and review what will be committed:

```bash
git add <file1> <file2> ... && git diff --cached
```

Then commit the changes. The commit message should follow the repo's existing style (Conventional Commits by default).

### Message

A commit must be self-contained. The message has three parts:

- Header: *where*. Provide enough distinguishing labels (the where) to differentiate this commit from others
    - Keep it concise, within 60 chars
- Body: *why*. Explains the reason, context, tradeoffs, or constraints that are not **obvious** from the code
    - Never invent reasons, context, or tradeoffs not supported by the diff, codebase, or user input
    - Never repeat the header
    - Never list file paths or implementation steps
    - Must wrap text to a fixed column width
    - Prefer blank lines or list items as visual separators
- Diff: *how*. The files and changes being committed

Together, they form a complete picture without redundancy.
