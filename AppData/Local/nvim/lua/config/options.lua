-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- use pwsh or powershell
require("lazyvim.util.terminal").setup("pwsh")
vim.o.shellcmdflag =
  "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';$PSStyle.OutputRendering='plaintext';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"

-- hide tabline
vim.opt.showtabline = 0

vim.opt.wrap = true
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
