local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function()
  local _, _, window = mux.spawn_window({})
  wezterm.time.call_after(0.1, function()
    window:gui_window():toggle_fullscreen()
  end)
end)
