-- 可以提供 profiles.lua 来添加特殊 profiles
local ok, result = pcall(require, "profiles")
Config.launch_menu = ok and result or {}
for _, item in ipairs({
  { label = "Windows PowerShell", args = { "pwsh" } },
  { label = "命令提示符", args = { "cmd.exe" } },
}) do
  table.insert(Config.launch_menu, item)
end

Config.default_prog = Config.launch_menu[1].args
Config.default_cwd = Wezterm.home_dir .. "/projects"
