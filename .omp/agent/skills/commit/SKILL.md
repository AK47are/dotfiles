---
name: commit
description: Create git commits with automatically generated messages. Groups unrelated changes into separate commits when appropriate.
hide: true
---

## Context

- Current git status: `git status`
- Current git diff (staged and unstaged changes): `git diff HEAD`
- Current branch: `git branch --show-current`
- Recent commits: `git log --oneline -10`

## Your task

Based on the above changes, create well-organized git commits. Good commit
hygiene means each commit represents exactly one logical change — this makes
history easier to review, bisect, and revert.

### How to group changes

Analyze what changed using git status file paths and git diff content:

1. **Together**: Changes that serve the same goal belong in the same commit. Multiple files modified for one feature or one bug fix → 1 commit. This is the default and most common case
2. **Separate**: Changes that address clearly independent concerns should be different commits. A bug fix in one module + a new feature in another → separate commits. Different directories are a useful signal, but always confirm by reading the diff content — two directories can still be part of the same feature work

Create 1 commit by default. Split into multiple commits (up to 5-6) when the independence is clear. Each commit must be self-contained (it should compile and make sense on its own). Never split changes that depend on each other.

### Creating the commits

For each logical group, in sequence:

1. `git add` only the specific files for that commit (never use `git add .`)
2. `git diff --cached` to verify the right changes are staged
3. `git commit` with a message that follows the repo's existing style (check recent commits for convention). Summary line max 50 chars, description lines max 72 chars. Describe WHY, not WHAT

If there are no recent commits to reference, use Conventional Commits specification.
