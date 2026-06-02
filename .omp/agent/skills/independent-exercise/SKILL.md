---
name: independent-exercise
description: Creates a self-contained exercise environment with test files, skeleton code, and solution reference. For learning new concepts (design patterns, concurrency, algorithms, language features) through hands-on practice, independent of any existing project code.
hide: true
---

## Output Structure

> **Note:** Generate this `README.md` file **last**, after completing all other files.

```
.exercises/<topic-slug>/
├── README.md          # Exercise instructions, learning objectives, hints
├── .git               # fake git flag to trick editors into treating this as project root
├── out/               # Generated/build output directory (optional)
├── run.ps1            # Run program command
├── test.ps1           # Run test command
├── <test-file>        # Test code
├── <skeleton-file>    # Skeleton code
└── .solution/         # Prepend `.` to avoid being parsed by LSP
    ├── out/           # Generated/build output directory (optional)
    ├── run.ps1        # Run solution program command
    ├── test.ps1       # Run solution test command
    ├── README.md      # Solution explanation — explains why this approach was taken
    └── <solution-file> # Complete reference implementation
```

> You must ensure that run.ps1 and test.ps1 in .solution/ can run normally from the beginning

Multi-task progressive exercise:

```
.exercises/<topic-slug>/
├── README.md            # Overall instructions and learning path
├── task-01-<sub-topic>/
    ├── .git
│   ├── README.md
    ├── out/
    ├── run.ps1
    ├── test.ps1
│   ├── <test-file>
│   ├── <skeleton-file>
│   └── .solution/
        ├── out/
        ├── run.ps1
        ├── test.ps1
│       ├── README.md
│       └── <solution-file>
├── task-02-<sub-topic>/
│   └── ...
```

## Exercise Template

```markdown
## Learning Objectives

- [Specific, verifiable objectives — not "understand X" but "implement X that can do Y"]

## Directory Structure

[List each file generated in this directory and explain what content it contains]

## Task Description

[Clearly describe what needs to be done]

- Starter code: [skeleton file path], provides [X], you need to implement [Y]

## Prerequisites

Must explain what each prerequisite is, why it is needed, the underlying principles, and how to use it.

Also explain any further prerequisites derived from these prerequisites clearly.
```
