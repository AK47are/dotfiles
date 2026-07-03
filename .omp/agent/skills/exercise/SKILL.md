---
name: exercise
description: Creates exercise environments with test files, skeleton code, and solution reference. For learning new concepts (design patterns, concurrency, algorithms, language features) through hands-on practice. Prefers self-contained exercises independent of existing project code; falls back to project-integrated exercises when self-containment would compromise learning quality.
hide: true
---

Read ./COMMENT-FORMAT.md for comment specifications.

## Self-Contained vs Project-Integrated

Default to **self-contained** exercises. All code, tests, and solutions live under `.omp/exercises/` with no dependency on the host project.

Consider **project-integrated** when self-containment would compromise learning quality:

- Exercise core requires the host project's existing classes/modules (e.g. "add caching to UserService")
- The exercise needs full project context to be meaningful (e.g. "understand this project's auth flow")
- Self-contained stubs would be too large or artificial, diluting the learning focus

### Override Flow

When self-containment is unsuitable, **pause and propose alternatives** before creating any files:

1. Analyze the exercise requirements and project structure
2. Propose 2–3 concrete approaches in a comparison table:

| Approach | Core Idea | Pros | Cons | Best For |
|----------|-----------|------|------|----------|
| A: ... | ... | ... | ... | ... |
| B: ... | ... | ... | ... | ... |

3. Recommend one approach with rationale
4. Wait for user selection before proceeding

### Project-Integrated Output Structure

For project-integrated exercises, code files go into the **project's actual directory structure** (where the build system expects them). Instructional materials stay in `.omp/exercises/`.

```
.omp/exercises/<topic-slug>/
└── README.md          # Instructions + file manifest + cleanup guide
```

The README must contain:

- **File Manifest**: Every file created or modified, with full paths relative to project root
- **Modification Description**: What was changed in each existing file and why
- **Cleanup Guide**: How to restore the project (delete added files + git checkout modified files)

No `.solution/` directory — the reference implementation is described in the README as a diff from the original project state.


## Output Structure

> **Note:** Generate this `README.md` file **last**, after completing all other files.

```
.omp/exercises/<topic-slug>/
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
.omp/exercises/<topic-slug>/
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

## Project-Integrated Exercise Template

```markdown
## Learning Objectives

- [Specific, verifiable objectives]

## Project Context

[Brief explanation of the relevant project code this exercise builds on. Link to the actual files.]

## Task Description

[Clearly describe what needs to be done]

## Prerequisites

[Same requirements as self-contained template]

## File Manifest

| Action | Path | Description |
|--------|------|-------------|
| Create | src/.../NewClass.java | [What this file does] |
| Modify | src/.../ExistingClass.java | [What was changed and why] |

## Reference Implementation

[Step-by-step description of the solution, explaining the approach and key decisions. Include code snippets for critical parts.]
```
