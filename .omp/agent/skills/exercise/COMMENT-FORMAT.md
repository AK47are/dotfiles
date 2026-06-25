## Comment Specification
All Ai-generated code comments must uniformly adopt the `tag: description` format. `[]` tags are optional, and a comment block may use multiple `[]` tags. The keyword is mandatory, with only one keyword per comment block, placed on the last line.

| Tag | Purpose |
|------|------|
| `[DESIGN]` | Architecture, patterns, data flow, component boundaries |
| `[IMPL]` | Function signature, key logic, edge cases |
| `[WHY]` | Non-obvious reasons: trade-offs, alternatives, constraints |
| `[REVIEW]` | Points to verify after implementation: bugs, performance, security, blind spots |
| `NOTE` | Design explanation — only for non-obvious decisions or reasons |
| `TODO` | To be implemented |
| `FIX` | Needs to be fixed |
| `WARN` | Caveats, pitfalls |
| `PERF` | Performance concerns |
| `TEST` | Testing requirements |
| `HACK` | Temporary workaround |

### Rules
- `[]` tags are optional; a comment block may use multiple `[]` tags (e.g., `[DESIGN]` + `[WHY]` + `[IMPL]` combination) to describe design intent from different perspectives
- The keyword must be followed by a description, e.g., `// NOTE: xxxx`, not just `// NOTE`
- Keywords must not be **abused** as generic comments, especially `NOTE`. Once abused, it becomes very confusing. Only use for non-obvious decisions worth documenting
### Examples
```
// NOTE: Must use thread-safe collection here

// TODO: Implement JWT authentication middleware

// [DESIGN]: Use strategy pattern to handle three payment channels
// NOTE: Dispatch to specific strategy
//       at runtime based on type field

// [REVIEW]: Handling of null key after capacity expansion
// FIX: Currently throws NPE
```
