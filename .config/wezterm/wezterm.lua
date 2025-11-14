local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.default_prog = { "pwsh" }
config.default_cwd = wezterm.home_dir .. "/projects"

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font("0xProto Nerd Font")
config.font_size = 12.0
config.line_height = 1.2
config.cell_width = 0.8
if wezterm.gui.get_appearance():find("Dark") then
	config.color_scheme = "Catppuccin Frappe"
else
	config.color_scheme = "Catppuccin Latte"
end

return config
