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
local imselect = vim.fn.stdpath("config") .. "/tools/im-select.exe"
if vim.fn.executable(imselect) == 0 then
  vim.notify("im-select.exe 未找到：" .. imselect, vim.log.levels.WARN)
else
  vim.system({ imselect, "1033" }) -- 刚进入 Vim 切换英文
  local imselect_augroup = augroup("ime-select")
  local ENGLISH_MODES = {
    n = true, -- Normal mode (普通模式)
    nt = true, -- N-Terminal mode (终端普通模式)
    no = true, -- Normal-Operator Pending mode (Normal模式下等待操作符)
    niI = true, -- insert 模式下使用 <Ctrl-o> 进入的临时 normal 模式

    v = true, -- Visual mode (字符可视)
    V = true, -- Visual Line mode (行可视)
    ["\x16"] = true, -- Visual Block mode，不能使用 ^V 代替

    c = true,
  }

  -- 进入 Vim、获得焦点或模式改变时，检查当前模式，仅允许特定模式切换为美式键盘
  vim.api.nvim_create_autocmd({ "FocusGained", "ModeChanged" }, {
    pattern = { "*" },
    group = imselect_augroup,
    callback = function(_)
      local mode = vim.api.nvim_get_mode().mode
      -- vim.notify(mode)
      if ENGLISH_MODES[mode] then
        vim.system({ imselect, "1033" }) -- 切换英文
      else
        vim.system({ imselect, "2052" }) -- 切换中文
      end
    end,
  })

  -- 失去焦点或退出 Vim 时切换会常用输入法——微软拼音
  vim.api.nvim_create_autocmd({ "FocusLost", "VimLeave" }, {
    pattern = { "*" },
    group = imselect_augroup,
    callback = function(args)
      -- 使用同步函数来保证退出前执行成功
      vim.system({ imselect, "2052" }):wait()
    end,
  })
end
