Config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
Config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

Wezterm.on("gui-startup", function(_)
  local screen = Wezterm.gui.screens().active
  local ratio = 0.7
  local width, height = screen.width * ratio, screen.height * ratio
  local _, _, window = Wezterm.mux.spawn_window({
    position = {
      x = (screen.width - width) / 2,
      y = (screen.height - height) / 2,
      origin = "ActiveScreen",
    },
  })
  -- window:gui_window():maximize()
  window:gui_window():set_inner_size(width, height)
end)

Config.hide_tab_bar_if_only_one_tab = true
Config.bold_brightens_ansi_colors = true
Config.front_end = "WebGpu"

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

Config.default_cursor_style = "BlinkingBar"
