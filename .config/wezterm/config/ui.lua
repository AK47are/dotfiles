local function resize_window_to_ratio(window, ratio)
  local screen = WezTerm.gui.screens().active
  local width, height = screen.width * ratio, screen.height * ratio
  window:set_inner_size(width, height - 10)
  window:set_position((screen.width - width) / 2, (screen.height - height) / 2 - 5)
  Cache.save("window_ratio", ratio)
end

Config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
Config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

WezTerm.on("gui-startup", function(cmd)
  -- 用 cmd 确保系统默认启动参数被传递
  local _, _, window = WezTerm.mux.spawn_window(cmd or {})
  resize_window_to_ratio(window:gui_window(), Cache.get("window_ratio") or 0.70)
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
  if WezTerm.gui.get_appearance():find("Dark") then
    Config.color_scheme = colorscheme.dark
  else
    Config.color_scheme = colorscheme.light
  end
  Cache.save("colorscheme", Config.color_scheme)
end

WezTerm.on("augment-command-palette", function(window, _)
  return {
    {
      brief = "Switch to Light Colorscheme",
      action = WezTerm.action_callback(function()
        window:set_config_overrides({ color_scheme = colorscheme.light })
        Cache.save("colorscheme", colorscheme.light)
      end),
    },
    {
      brief = "Switch to Dark Colorscheme",
      action = WezTerm.action_callback(function()
        window:set_config_overrides({ color_scheme = colorscheme.dark })
        Cache.save("colorscheme", colorscheme.dark)
      end),
    },
    {
      brief = "Set Window Size (100%)",
      action = WezTerm.action_callback(function(_)
        resize_window_to_ratio(window, 1.00)
      end),
    },
    {
      brief = "Set Window Size (70%)",
      action = WezTerm.action_callback(function(_)
        resize_window_to_ratio(window, 0.70)
      end),
    },
  }
end)

Config.default_cursor_style = "BlinkingBar"
Config.adjust_window_size_when_changing_font_size = false
Config.font_size = 11.0
