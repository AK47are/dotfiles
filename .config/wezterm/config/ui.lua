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

local cached_scheme = Cache.get("colorscheme")
if cached_scheme then
  Config.color_scheme = cached_scheme
else
  if Wezterm.gui.get_appearance():find("Dark") then
    Config.color_scheme = colorscheme.dark
  else
    Config.color_scheme = colorscheme.light
  end
  Cache.save("colorscheme", Config.color_scheme)
end

Wezterm.on("augment-command-palette", function(window, _)
  return {
    {
      brief = "Switch to Light Colorscheme",
      action = Wezterm.action_callback(function()
        window:set_config_overrides({ color_scheme = colorscheme.light })
        Cache.save("colorscheme", colorscheme.light)
      end),
    },
    {
      brief = "Switch to Dark Colorscheme",
      action = Wezterm.action_callback(function()
        window:set_config_overrides({ color_scheme = colorscheme.dark })
        Cache.save("colorscheme", colorscheme.dark)
      end),
    },
  }
end)
