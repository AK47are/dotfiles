---
name: obs-link
description: Create a Junction (folder) or HardLink (file) pointing to `~\obsidian\notes\AI 文档\`
hide: true
---

Create a link to `~\obsidian\notes\AI 文档\{a suitable name}` using `New-Item -ItemType <type> -Target <sourcePath>`. Obsidian does not support symlinks — folders use `Junction`, files use `HardLink`.
