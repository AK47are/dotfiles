---
name: boolean-style
description: Boolean variable naming and function parameter design conventions
alwaysApply: true
---

## Boolean Style

### Four Prefixes

Use these four prefixes paired with the correct part of speech. Applies to both camelCase and snake_case:

- `is` + adjective: state or identity
- `has` + noun: ownership or containment
- `can` + verb: capability or permission
- `should` + verb: intent or business logic

### No Negatives

MUST NOT use negation in boolean names. Avoid `isNotEnabled`, `hasNoAccess`, `isDisabled`.

`if (!isDisabled)` forces a double negative. `if (isEnabled)` is immediate.

Exception: when mirroring an external API with negative naming (e.g. HTML `noValidate`), keep it at the boundary and map to positive in domain logic: `bool shouldValidate = !request.noValidate;`

### Boolean Params

MUST NOT pass bare boolean literals as function arguments. `Execute(false, true, false)` carries zero information at the call site.

Fix with:
- Split method: `SendImmediately()` / `SendQueued()` instead of `Send(msg, true)`
- Enum: `file.Write(data, WriteMode.Append)` instead of `file.Write(data, true)`
- Config object: `export.Execute(new ExportOptions { Script = false, Export = true })`
