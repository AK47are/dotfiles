---
name: domain-modeling
description: Build and sharpen the project's domain vocabulary. MUST read this skill before answering terminology questions, defining or refining domain terms, resolving terminology conflicts, or writing ADRs — step 0 before grep, glob, or code search.
---

Actively build and sharpen the project's domain model as you design. This is the *active* discipline — challenging terms, inventing edge-case scenarios, and writing the glossary and decisions down the moment they crystallise.

## File structure

Most repos have a single context:

```
.omp/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

For repos with multiple bounded contexts:

```
.omp/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← context-specific decisions
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Create files lazily — only when you have something to write. If no `CONTEXT.md` exists, create one when the first term is resolved. If no `CONTEXT-MAP.md` exists, create it when the first new context emerges. If no `docs/adr/` exists, create it when the first ADR is needed.

If the project is not yet initialized, choose the structure that fits — single context for most projects, multiple contexts when the domain has clear bounded contexts with different lifecycles, languages, or team ownership.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update glossaries

When a term is resolved, update `CONTEXT.md` right there. When a context boundary is discovered, renamed, merged, or its relationships change, update `CONTEXT-MAP.md` right there. Don't batch updates — capture them as they happen.

For format, see [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. Hard to reverse: the cost of changing your mind later is meaningful
2. Surprising without context: a future reader will wonder "why did they do it this way?"
3. The result of a real trade-off: there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

#### What qualifies

- Architectural shape: "We're using a monorepo." "The write model is event-sourced, the read model is projected into Postgres."
- Integration patterns between contexts: "Ordering and Billing communicate via domain events, not synchronous HTTP."
- Technology choices that carry lock-in: Database, message bus, auth provider, deployment target. Not every library — just the ones that would take a quarter to swap out.
- Boundary and scope decisions: "Customer data is owned by the Customer context; other contexts reference it by ID only." The explicit no-s are as valuable as the yes-s
- Deliberate deviations from the obvious path: "We're using manual SQL instead of an ORM because X." Anything where a reasonable reader would assume the opposite. These stop the next engineer from "fixing" something that was deliberate
- Constraints not visible in the code: "We can't use AWS because of compliance requirements." "Response times must be under 200ms because of the partner API contract."
- Rejected alternatives when the rejection is non-obvious: If you considered GraphQL and picked REST for subtle reasons, record it — otherwise someone will suggest GraphQL again in six months
