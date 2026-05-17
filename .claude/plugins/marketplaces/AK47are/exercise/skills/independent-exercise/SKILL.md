---
name: independent-exercise
Description: Creates a self-contained exercise environment with test files, skeleton code, and solution reference. For learning new concepts (design patterns, concurrency, algorithms, language features) through hands-on practice, independent of any existing project code.
disable-model-invocation: true
---

## Output Structure

> **Note:** Generate this `README.md` file **last**, after completing all other files.

```
./.claude/exercises/<topic-slug>/
├── README.md          # Exercise instructions, learning objectives, hints
├── <test-file>        # Test code
├── <skeleton-file>    # Skeleton code
└── .solution/         # Prepend `.` to avoid being parsed by LSP
    ├── README.md      # Solution explanation — explains why this approach was taken
    └── <solution-file> # Complete reference implementation
```

Multi-task progressive exercise:

```
./.claude/exercises/<topic-slug>/
├── README.md            # Overall instructions and learning path
├── task-01-<sub-topic>/
│   ├── README.md
│   ├── <test-file>
│   ├── <skeleton-file>
│   └── .solution/
│       ├── README.md
│       └── <solution-file>
├── task-02-<sub-topic>/
│   └── ...
```

## Exercise Template

```markdown
## Learning Objectives

- [Specific, verifiable objectives — not "understand X" but "implement X that can do Y"]

## Prerequisites

Must explain what each prerequisite is, why it is needed, the underlying principles, and how to use it.

Also explain any further prerequisites derived from these prerequisites clearly.

## Task Description

[Clearly describe what needs to be done]

- Verification: Run `[command]`, see test cases at [test file path or list them directly]
- Starter code: [skeleton file path], provides [X], you need to implement [Y]

## Directory Structure

[List each file generated in this directory and explain what content it contains]
```
