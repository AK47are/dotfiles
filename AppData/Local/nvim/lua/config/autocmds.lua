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

local switchToEN = vim.fn.stdpath("config") .. "/utils/switchToEN.ahk"
if vim.fn.filereadable(switchToEN) == 1 then
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = augroup("english_mode"),
    callback = function()
      vim.system({ "autohotkey", switchToEN }) -- 切换英文
    end,
  })
else
  vim.notify(
    "AutoHotkey 脚本未找到：" .. switchToEN .. "。输入法切换功能未启用。",
    vim.log.levels.WARN,
    { title = "IME Switch Warning" }
  )
end

vim.api.nvim_create_autocmd("VimLeave", {
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
