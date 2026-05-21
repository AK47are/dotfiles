---
name: markdown-style
description: Markdown file formatting style guide
condition: [".*"]
scope: ["tool:edit(**/*.md)", "tool:write(**/*.md)"]
interruptMode: never
---

## Makrdown Style

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

- Only use for keyword emphasis, do not bold entire sentences or list items
- Avoid multiple bold words in a single sentence

### Chinese quotes

- Always use `「」`, do not use `“ ”`

### Punctuation spacing

- No spaces around Chinese punctuation（。，：（））
- Add spaces around English punctuation and code spans in mixed text

### Extended syntax

- Only use necessary extended syntax (tables, lists, etc.)
- Exception: Callouts are allowed

### Colons

- When a paragraph is not finished but needs to insert other elements (e.g., code blocks, images), add `:` at the end

### Content overview

- Each heading (including the filename) should have an overview paragraph before the next level heading

### Tables

- Do not add any punctuation at the end of table cells
