-- 持久化一些配置选项，全局可用
local wezterm = require("wezterm")
local SETTINGS_PATH = wezterm.home_dir .. "/.cache/wezterm_settings.json"

local M = {}
M.cache = {}

M.setup = function()
  do
    local f = io.open(SETTINGS_PATH, "r")
    if f then
      local content = f:read("*a")
      f:close()
      local ok, data = pcall(wezterm.json_parse, content)
      if ok and type(data) == "table" then
        M.cache = data
      end
    end
  end
  return M
end

M.get = function(key)
  return M.cache[key]
end

M.save = function(key, value)
  M.cache[key] = value
  local file = io.open(SETTINGS_PATH, "w")
  if file then
    local json_string = wezterm.json_encode(M.cache)
    file:write(json_string)
    file:close()
  end
end

return M
