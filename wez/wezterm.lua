local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux

config.color_scheme = 'Batman'
config.inactive_pane_hsb = {
  saturation = 1.0,
  brightness = 1.0,
}
config.window_background_opacity = 0.7

config.window_background_gradient = {
  -- Can be "Vertical" or "Horizontal".  Specifies the direction
  -- in which the color gradient varies.  The default is "Horizontal",
  -- with the gradient going from left-to-right.
  -- Linear and Radial gradients are also supported; see the other
  -- examples below
  orientation = 'Vertical',

  -- Specifies the set of colors that are interpolated in the gradient.
  -- Accepts CSS style color specs, from named colors, through rgb
  -- strings and more
  colors = {
    '#0f0c29',
    '#302b63',
    '#24243e',
  },

  -- Instead of specifying `colors`, you can use one of a number of
  -- predefined, preset gradients.
  -- A list of presets is shown in a section below.
  -- preset = "Warm",

  -- Specifies the interpolation style to be used.
  -- "Linear", "Basis" and "CatmullRom" as supported.
  -- The default is "Linear".
  interpolation = 'Linear',

  -- How the colors are blended in the gradient.
  -- "Rgb", "LinearRgb", "Hsv" and "Oklab" are supported.
  -- The default is "Rgb".
  blend = 'Rgb',

  -- To avoid vertical color banding for horizontal gradients, the
  -- gradient position is randomly shifted by up to the `noise` value
  -- for each pixel.
  -- Smaller values, or 0, will make bands more prominent.
  -- The default value is 64 which gives decent looking results
  -- on a retina macbook pro display.
  -- noise = 64,

  -- By default, the gradient smoothly transitions between the colors.
  -- You can adjust the sharpness by specifying the segment_size and
  -- segment_smoothness parameters.
  -- segment_size configures how many segments are present.
  -- segment_smoothness is how hard the edge is; 0.0 is a hard edge,
  -- 1.0 is a soft edge.

  -- segment_size = 11,
  -- segment_smoothness = 0.0,
}

wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    local gui_window = window:gui_window()
    gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
end)

return {
    default_prog = { "/bin/zsh" },
    font_dirs = { "/Users/ebuckshi/Library/Fonts" },
    window_decorations = "NONE", -- Hides the titlebar and borders
    window_padding = {
        left = 10,
        right = 10,
        top = 10,
        bottom = 10,
    },
    enable_tab_bar = false, -- Optional: Hide the tab bar
    full_screen = true, -- Enable fullscreen at startup
    font = wezterm.font("Hack Nerd Font Mono"),
    font_size = 12.0,
    colors = {
        foreground = '#0cf907', -- Bright neon green
    },
    enable_tab_bar = true,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 60,
    },
    scroll_to_bottom_on_input = true,
    scrollback_lines = 100000,
    keys = {
        {key="t", mods="CTRL|SHIFT", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
        {key="w", mods="CTRL|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
        {key="1", mods="CTRL|SHIFT", action=wezterm.action{ActivateTab=0}},
        {key="2", mods="CTRL|SHIFT", action=wezterm.action{ActivateTab=1}},
        {key="3", mods="CTRL|SHIFT", action=wezterm.action{ActivateTab=2}},
        {key="4", mods="CTRL|SHIFT", action=wezterm.action{ActivateTab=3}},
        {key="5", mods="CTRL|SHIFT", action=wezterm.action{ActivateTab=4}},
        {key="6", mods="CTRL|SHIFT", action=wezterm.action{ActivateTab=5}},
        {key="7", mods="CTRL|SHIFT", action=wezterm.action{ActivateTab=6}},
        {key="8", mods="CTRL|SHIFT", action=wezterm.action{ActivateTab=7}},
        {key="9", mods="CTRL|SHIFT", action=wezterm.action{ActivateTab=-1}},  -- Last tab
        {key = "LeftArrow",  mods = "SHIFT", action = wezterm.action{ActivateTabRelative = -1}},
        {key = "RightArrow", mods = "SHIFT", action = wezterm.action{ActivateTabRelative = 1}},
    }
}
