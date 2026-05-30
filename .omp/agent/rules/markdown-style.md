---
name: markdown-style
description: Markdown file formatting style guide
condition: [".*"]
scope: ["tool:edit(**/*.md)", "tool:write(**/*.md)"]
interruptMode: never
---

## Markdown Style

### Lists

- Do not add any punctuation at the end of list items
- If a list item is long or needs to contain images/code blocks:
  - Images: Place on the **next line** under the current list item, no indentation
  - Code blocks: Place **two lines** under the current list item, no indentation
  - Multi-line text: Use sub-lists or headings instead

### Links

- Add spaces between Chinese and English text, otherwise do not add spaces
- Use standard inline links `[text](url)`, do not use Wiki links

### Bold text

- Only for keyword emphasis — never bold entire sentences, list items, or table cells
- Repeated organizational patterns (list markers, table headers, recurring labels) should not use bold; bold is reserved for content-level emphasis, not structural highlighting

### Chinese quotes

- Always use `「」`, do not use `“ ”`

### Punctuation spacing

- Add spaces around English punctuation and code spans in mixed text
- No spaces needed around special styles (bold, italic, links, etc.) to separate from other content; only follow the Chinese-English spacing rule. For example: `一个 [Test 链接](xxx)在这里`

### Colons

- When a paragraph is not finished but needs to insert other elements (e.g., code blocks, images), add `:` at the end

### Heading

- Each heading (including the filename) should have an overview paragraph before the next level heading
- Do not use list numbers in headings

### Tables

- Do not add any punctuation at the end of table cells
