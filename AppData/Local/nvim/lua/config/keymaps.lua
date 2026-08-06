-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- 删除窗口聚焦快捷键
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")
-- 删除默认窗口调整快捷键
vim.keymap.del("n", "<C-Right>")
vim.keymap.del("n", "<C-Left>")
vim.keymap.del("n", "<C-Up>")
vim.keymap.del("n", "<C-Down>")
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

if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gc", function()
    local home = vim.fn.expand("$HOME")
    Snacks.terminal({
      "lazygit",
      "--git-dir=" .. home .. "/.cfg",
      "--work-tree=" .. home,
    }, { cwd = home })
  end, { desc = "Lazygit (Dotfiles)" })
end

map("n", "q", "<Nop>")
map("n", "<leader>Q", "q", { desc = "Record Macro" })

map("n", "<localleader>y", function()
  vim.fn.setreg("*", vim.fn.expand("%:p"))
end, { desc = "Copy current file absolute path" })

vim.keymap.set("n", "gf", "gF")
