#!/bin/sh

# If picom is already running, kill it to "turn off" the inversion
if pgrep -x "picom" >/dev/null; then
  pkill -x picom
else
  # Get the ID of the currently focused window
  # We use xdotool which should be available in the user's environment
  ID=$(xdotool getwindowfocus getwindowclassname)

  if [ -n "$ID" ]; then
    # Start picom and invert only the window with the given ID.
    # We use the xrender backend for better compatibility with this type of inversion,
    # similar to the synergy_invert.sh script.
    picom --backend xrender --invert-color-include "class_g = '$ID'" &
  fi
fi
