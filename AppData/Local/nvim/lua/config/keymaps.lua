-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- 重映射窗口聚焦快捷键
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")
map("n", "<A-h>", "<C-W>h", { desc = "Go to Left Window", remap = true })
map("n", "<A-j>", "<C-W>j", { desc = "Go to Upper Window", remap = true })
map("n", "<A-k>", "<C-W>k", { desc = "Go to Lower Window", remap = true })
map("n", "<A-l>", "<C-W>l", { desc = "Go to Right Window", remap = true })

map("t", "<A-h>", [[<C-\><C-n><C-w>h]], { desc = "Go to Left Window" })
map("t", "<A-j>", [[<C-\><C-n><C-w>j]], { desc = "Go to Lower Window" })
map("t", "<A-k>", [[<C-\><C-n><C-w>k]], { desc = "Go to Upper Window" })
map("t", "<A-l>", [[<C-\><C-n><C-w>l]], { desc = "Go to Right Window" })
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit Terminal Mode" })

-- 删除 insert 模式下默认的行移动映射，由于冲突而重新映射
vim.keymap.del("i", "<A-j>") -- <C-j> 和原生 <C-j> -> <CR> 冲突
vim.keymap.del("i", "<A-k>") -- <C-k> 和 Lsp 默认快捷键冲突

-- 重映射行移动快捷键
-- 使用 silent 避免出现命令框闪烁
map("n", "<C-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<C-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("v", "<C-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down", silent = true })
map("v", "<C-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up", silent = true })

map({ "n", "x" }, "s", "ciw", { silent = true })
