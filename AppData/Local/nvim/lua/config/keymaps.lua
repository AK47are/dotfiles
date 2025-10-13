-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 重映射窗口聚焦快捷键
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")
vim.keymap.set("n", "<A-h>", "<C-W>h", { desc = "Go to Left Window", silent = true })
vim.keymap.set("n", "<A-j>", "<C-W>j", { desc = "Go to Upper Window", silent = true })
vim.keymap.set("n", "<A-k>", "<C-W>k", { desc = "Go to Lower Window", silent = true })
vim.keymap.set("n", "<A-l>", "<C-W>l", { desc = "Go to Right Window", silent = true })
