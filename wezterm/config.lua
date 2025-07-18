local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.automatically_reload_config = true

config.font_size = 14.0
-- config.color_scheme = 'cyberpunk'
-- config.color_scheme = 'Dark Violet (base16)'
-- config.color_scheme = 'VisiBlue (terminal.sexy)'
config.color_scheme = 'SeaShells'

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false

config.default_cursor_style = "SteadyBar"

config.window_decorations = "NONE"
config.window_close_confirmation = "NeverPrompt"
-- config.window_background_opacity = 0.95
config.window_padding = {
  left = 3,
  right = 3,
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
  -- Navigation
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = '`',
    mods = 'CTRL',
    action = wezterm.action.SplitPane {
      direction = 'Down',
      size = { Percent = 40 }
    },
  },
}

return config
