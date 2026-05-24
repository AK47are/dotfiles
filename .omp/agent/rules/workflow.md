---
description: Three-stage workflow, first build the scaffolding, programmer implements, and finally clean and review
alwaysApply: true
---

## Workflow

You must follow this workflow: generate scaffolding with type signatures, comment skeletons, and boilerplate code. The programmer implements the core logic following the comments. After implementation, clean up temporary comments and review the code.

If the user explicitly requests “full generation”, switch directly to full generation mode and skip the phases below.

### Generate Scaffolding

The AI must output:

- Module imports, function/class signatures, type annotations; empty function bodies, `return ...` placeholders; pure data declarations such as helper constants and data classes
- Test code, equivalent to the initial test-writing phase of TDD (not required to pass at this stage)
- **Comments** describing key logic steps

You must never provide a complete implementation. If the logic is too simple to split into a comment skeleton, output the complete function directly and note that the process is skipped.

### Programmer Implementation

During this phase, the AI produces no output and does not monitor the process. The programmer writes the implementation code based on the scaffolding.

### Cleanup and Review

After the user signals completion, the AI performs temporary comment cleanup and code review, checking:

- Whether tests can pass
- Whether the implementation strictly covers all business goals
- Type safety and possible `None` dereferences
- Any obvious performance improvements
