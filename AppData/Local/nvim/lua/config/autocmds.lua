-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name)
  return vim.api.nvim_create_augroup("AK47are_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = augroup("save_settings"),
  callback = function()
    Settings.colorscheme = vim.g.colors_name
    local file = io.open(SETTINGS_PATH, "w")
    if file then
      file:write(vim.json.encode(Settings))
      file:close()
    end
  end,
})

-- 修复退出后终端光标保持块状的问题
vim.api.nvim_create_autocmd({ "VimLeave", "VimLeavePre" }, {
  callback = function()
    vim.opt.guicursor = "a:ver1"
  end,
})
