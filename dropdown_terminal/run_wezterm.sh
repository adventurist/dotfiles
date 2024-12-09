#!/bin/bash
log="${HOME}/wezrunner.log"
myecho() {
    echo "$@" >> $log
}

PREFERRED_MONITOR="HDMI-1"
FALLBACK_MONITOR="eDP-1"

MONITOR_GEOMETRY=$(xrandr | grep "^$PREFERRED_MONITOR connected" | awk '{print $3}' | sed 's/+.*//')
if [ -z "$MONITOR_GEOMETRY" ]; then
    MONITOR_GEOMETRY=$(xrandr | grep "^$FALLBACK_MONITOR connected" | awk '{print $3}' | sed 's/+.*//')
fi

if [ -z "$MONITOR_GEOMETRY" ]; then
    MONITOR_GEOMETRY=$(xrandr | grep " connected" | awk '{print $3}' | sed 's/+.*//' | head -n 1)
fi

myecho "Primary Monitor: $PRIMARY_MONITOR"
myecho "Monitor Geometry: $MONITOR_GEOMETRY"

WINDOW_ID=$(wmctrl -lx | grep -i "org.wezfurlong.wezterm" | awk '{print $1}')
if [ -n "$WINDOW_ID" ]; then
    myecho "Found windowID $WINDOW_ID"
  
    xwininfo -id "$WINDOW_ID" | grep -q "Map State: IsViewable"
    if [ $? -eq 0 ]; then
      # If visible, hide it
      myecho 'is viewable'
      xdotool windowminimize "$WINDOW_ID"
    else
        # If hidden, show it
        myecho "is not viewable"
        xdotool windowmap "$WINDOW_ID"
        xdotool windowsize "$WINDOW_ID" "$MONITOR_GEOMETRY"
        wmctrl -i -r "$WINDOW_ID" -b add,above
        xdotool windowactivate "$WINDOW_ID"
    fi
else
    myecho "no window. starting a new wezterm"
    wezterm start&
fi

