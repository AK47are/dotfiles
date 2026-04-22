WezTerm = require("wezterm")
Config = WezTerm.config_builder()
Cache = require("utils.persist").setup()

local LOAD_FILE = {
  "ui.lua",
  "options.lua",
  "smart-split.lua",
}

for _, item in ipairs(LOAD_FILE) do
  dofile(WezTerm.config_dir .. "/config/" .. item)
end

return Config
