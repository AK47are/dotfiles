-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 持久化一些配置选项，全局可用
SETTINGS_PATH = vim.fn.stdpath("cache") .. "/settings.json"
Settings = {}
do
  local f = io.open(SETTINGS_PATH, "r")
  if f then
    local content = f:read("*a")
    f:close()
    local ok, data = pcall(vim.json.decode, content)
    if ok then
      Settings = data
    end
  end
end

-- use pwsh or powershell
require("lazyvim.util.terminal").setup("pwsh")
vim.o.shellcmdflag =
  "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';$PSStyle.OutputRendering='plaintext';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"

-- hide tabline
-- vim.opt.showtabline = 0

-- vim.opt.wrap = true
-- 保证中文 wrap 正常，虽然会使得英文可读性降低
vim.opt.linebreak = false

-- https://github.com/LazyVim/LazyVim/discussions/3669
vim.api.nvim_create_user_command("ClearShada", function()
  local shada_path = vim.fn.expand(vim.fn.stdpath("data") .. "/shada")
  local files = vim.fn.glob(shada_path .. "/*", false, true)
  local all_success = 0
  for _, file in ipairs(files) do
    local file_name = vim.fn.fnamemodify(file, ":t")
    if file_name == "main.shada" then
      -- skip your main.shada file
      goto continue
    end
    local success = vim.fn.delete(file)
    all_success = all_success + success
    if success ~= 0 then
      vim.notify("Couldn't delete file '" .. file_name .. "'", vim.log.levels.WARN)
    end
    ::continue::
  end
  if all_success == 0 then
    vim.print("Successfully deleted all temporary shada files")
  end
end, { desc = "Clears all the .tmp shada files" })

vim.g.snacks_animate = false

-- 设置命令行模式为竖线，其他模式保持原样
vim.o.guicursor = table.concat({
  "n-v-sm:block",
  "i-c-ci-ve:ver25",
  "r-cr-o:hor20",
  "t:block-blinkon500-blinkoff500-TermCursor",
}, ",")

-- use unix style to parse file
vim.opt.fileformats = { "unix", "dos", "mac" }
-- set unix style to save file
vim.opt.fileformat = "unix"

-- vim.g.lazyvim_prettier_needs_config = true
vim.opt.swapfile = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
