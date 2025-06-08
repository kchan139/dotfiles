local wezterm = require("wezterm")
local mux = wezterm.mux

-- wezterm.on("gui-startup", function()
--   local _, _, window = mux.spawn_window({})
--   window:gui_window():maximize()
-- end)
wezterm.on("gui-startup", function()
  local _, _, window = mux.spawn_window({})
  local gui_window = window:gui_window()
  
  -- Get screen info using a different approach
  wezterm.time.call_after(0.1, function()
    -- Try getting screen dimensions from the active screen
    local screens = wezterm.gui.screens()
    if screens and screens.active then
      local screen = screens.active
      local width = math.floor(screen.width * 1)
      local height = math.floor(screen.height * 1)
      local x = math.floor((screen.width - width) / 2)
      local y = math.floor((screen.height - height) / 2)
            
      gui_window:set_position(x, y)
      gui_window:set_inner_size(width, height)
    end
  end)
end)

-- wezterm.on("window-resized", function(window, pane)
-- 	readjust_font_size(window, pane)
-- end)
