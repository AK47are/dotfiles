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

-- 自动切换输入法，需要微软美式键盘和微软拼音
-- 可选：打开输入法设置的「为不同应用使用不同输入法」
-- 不设置可选功能，可能导致中文输入法受到外部应用影响，一直处于中文状态
-- 必须修改外部应用（如浏览器）输入框时中文输入法状态才能解决
local imselect = vim.fn.stdpath("config") .. "/tools/im-select.exe"
if vim.fn.executable(imselect) == 0 then
  vim.notify("im-select.exe 未找到：" .. imselect, vim.log.levels.WARN)
else
  vim.system({ imselect, "1033" }) -- 刚进入 Vim 切换英文，VimEnter 无法触发，原因未知
  local imselect_augroup = augroup("ime-select")

  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = { "*" },
    group = imselect_augroup,
    callback = function()
      vim.system({ imselect, "1033" }) -- 切换英文
    end,
  })

  vim.api.nvim_create_autocmd({ "InsertEnter", "VimLeave" }, {
    pattern = { "*" },
    group = imselect_augroup,
    callback = function(_)
      -- 使用同步函数来保证退出前执行成功
      vim.system({ imselect, "2052" }):wait()
    end,
  })
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
