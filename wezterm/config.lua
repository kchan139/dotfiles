local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.automatically_reload_config = true
config.enable_wayland = false

config.font_size = 14.0
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.color_scheme = 'SeaShells'

config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false

config.default_cursor_style = "SteadyBar"

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.window_padding = {
  left = 25,
  right = 25,
  top = 0,
  bottom = 0,
}

config.text_background_opacity = 1.0

config.background = {
  {
    source = {
      File = os.getenv("HOME") .. "/dotfiles/img/sand_dunes.jpg",
    },
    hsb = {
      hue = 1.0,
      saturation = 1.02,
      brightness = 0.25,
    },
  },
  {
    source = {
      Color = "#282c35",
    },
    width = "100%",
    height = "100%",
    opacity = 0.55,
  },
}

config.keys = {
  {
    key = 'n',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.ToggleFullScreen,
  },
}

return config
