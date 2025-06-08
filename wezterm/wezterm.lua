local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window{}
  window:gui_window():maximize()
end)

config.font_size = 13.0
config.color_scheme = 'Catppuccin Macchiato'

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.text_background_opacity = 1.0

return config
