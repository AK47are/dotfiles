-- 通过修改 profiles 来添加依赖系统的 profiles
local profiles = Cache.get("profiles")
local default_profiles = {
  { label = "Windows PowerShell", args = { "pwsh" } },
  { label = "命令提示符", args = { "cmd.exe" } },
}
if not profiles then
  profiles = default_profiles
  Cache.save("profiles", profiles)
end
Config.launch_menu = Config.launch_menu or {}
for _, item in ipairs(profiles) do
  table.insert(Config.launch_menu, item)
end

Config.default_prog = profiles[1].args
Config.default_cwd = WezTerm.home_dir .. "/projects"
