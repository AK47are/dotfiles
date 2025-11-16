Config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
Config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

Config.hide_tab_bar_if_only_one_tab = true

Config.font = Wezterm.font("0xProto Nerd Font")
Config.font_size = 12.0
Config.line_height = 1.2
Config.cell_width = 0.8
local colorscheme = {
  dark = "Catppuccin Frappe",
  light = "Catppuccin Latte",
}
if Wezterm.gui.get_appearance():find("Dark") then
  Config.color_scheme = colorscheme.dark
else
  Config.color_scheme = colorscheme.light
end

Wezterm.on("augment-command-palette", function(window, _)
  return {
    {
      brief = "Switch to Light Colorscheme",
      action = Wezterm.action_callback(function()
        window:set_config_overrides({ color_scheme = colorscheme.light })
      end),
    },
    {
      brief = "Switch to Dark Colorscheme",
      action = Wezterm.action_callback(function()
        window:set_config_overrides({ color_scheme = colorscheme.dark })
      end),
    },
  }
end)
