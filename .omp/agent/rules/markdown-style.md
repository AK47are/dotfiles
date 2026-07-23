---
name: markdown-style
description: Markdown file formatting style guide
alwaysApply: true
---

## Markdown Style

### Headings

- Each heading (including the filename) should have an overview paragraph before the next level heading. Overview paragraphs should define the core concept in one concise sentence, then briefly explain—in up to two succinct paragraphs—why the sub‑topics are grouped together, without restating the heading or expanding into details
- Heading length cannot exceed 20 characters
- **Never** use the first-level heading `# `
- **Never** use numeric headings like `## 1` or `## 方式一`, nor any enumerative organizational scheme
- The filename serves as the implicit first-level heading. Inside the file body:
  - Never repeat the filename as any level of heading (no `#`, `##`, etc. that matches the filename)
  - Start directly with an overview paragraph — no heading before it

### Punctuation and quotes

- Do not add any punctuation at the end of **list line**（Unless `:`, `：`）
- Do not add any punctuation at the end of **table cells**
- When a paragraph is not finished and needs to insert other elements (e.g., code blocks, images, lists, tables), add an explicit lead-in phrase such as `例如` or `如下`, then end with a colon (`:` or `：`)
  - A paragraph immediately followed by a list (no blank line) is always considered unfinished and must follow this rule
- Always use `「」`, do not use `“ ”`

### Lists

- If a list item is long or needs to contain images/code blocks:
  - Images: Place on the **next line** under the current list item, no indentation
  - Code blocks: Place **two lines** under the current list item, no indentation
  - Multi-line text: Use sub-lists or headings instead

### Text formatting

- Only for keyword emphasis — never bold entire sentences, list items, or table cells
- Bold is reserved for stand-alone inline emphasis (e.g., a critical term in a paragraph). Never use bold inside any list item, table cell, or heading — even for keywords. List markers, table headers, and recurring labels are inherently structural and must remain plain text.
- Use standard inline links `[text](url)`, do not use Wiki links
- Add spaces between Chinese and English text (including in filenames); otherwise, do not add spaces. Spaces are
 determined by visible characters only — markup syntax (bold, italic, links, etc.) is ignored. Such as:
    - Prefer `一个 [Test 链接](xxx)在这里` over `一个 [Test 链接](xxx) 在这里`
    - Prefer `一个**例子 Example** 在这里` over `一个 **例子 Example** 在这里`
    - Prefer `文件名 Report.pdf` over `文件名Report.pdf`

### Extension

- Allow Callout for enhanced content presentation, with the following syntax:

```md
> [!TYPE][+|-] title
> content
```

- Allow mermaid diagrams to illustrate logic such as flow, hierarchy, or state transitions

### Never Used

- Never use horizontal rules: `---`
- Never use em dashes

