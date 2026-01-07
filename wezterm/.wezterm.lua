local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font('MesloLGS NF')
config.font_size = 14.0

config.keys = {
  {key="Enter", mods="SHIFT", action=wezterm.action{SendString="\x1b\r"}},
  -- Option+Enter: Insert newline (prevents fullscreen toggle)
  {key="Enter", mods="ALT", action=wezterm.action{SendString="\n"}},
  -- Command+Left: Go to beginning of line
  {key="LeftArrow", mods="CMD", action=wezterm.action{SendString="\x01"}},
  -- Command+Right: Go to end of line
  {key="RightArrow", mods="CMD", action=wezterm.action{SendString="\x05"}},
  -- Command+Delete: Delete from cursor to beginning of line
  {key="Backspace", mods="CMD", action=wezterm.action{SendString="\x15"}},
  -- Option+Delete: Delete word backward
  {key="Backspace", mods="ALT", action=wezterm.action{SendString="\x17"}},
}

config.mouse_bindings = {
  -- Command-click opens hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

return config
