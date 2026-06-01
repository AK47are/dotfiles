#!/usr/bin/env pwsh
# lazygit external diff command wrapper for Windows
# Enables delta word-level diff highlighting
# See https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md

$old = $args[1].Replace('\', '/')
$new = $args[4].Replace('\', '/')
$path = $args[0]
git diff --no-index --no-ext-diff $old $new | delta --paging=never --color-only --dark --line-numbers --width=$env:LAZYGIT_COLUMNS
