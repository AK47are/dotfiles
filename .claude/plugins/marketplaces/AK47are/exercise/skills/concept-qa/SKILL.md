---
name: concept-qa
description: Generates a concept Q&A exercise with question list and reference answers. Designed for deep understanding of concepts, distinguishing similar concepts, or theoretical questions that cannot be verified with code.
disable-model-invocation: true
---

## Output Structure

> **Note:** Generate this `README.md` file **last**, after completing all other files.

```
./.claude/exercises/<topic-slug>-qa/
├── questions.md       # Question list (user answer area)
├── answers.md         # Reference answers (includes in-depth explanations and examples)
└── README.md          # Explains learning objectives and prerequisites
```

## README Template

```markdown
## Learning Objectives

- [Specific, verifiable objectives — not "know X" but "be able to explain the difference between X and Y with examples"]

## Prerequisites

Must explain what each prerequisite is, why it is needed, the underlying principles, and how to use it.

Also explain any further prerequisites derived from these prerequisites clearly.

## Directory Structure

[List each file generated in this directory and explain what content it contains]
```
