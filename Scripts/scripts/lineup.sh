#!/usr/bin/env bash

line_up() {
  local win_id win_x win_y win_width win_height
  local center_x center_y

  # Get the currently focused window ID
  win_id=$(xdotool getwindowfocus)

  # Get the window's position and dimensions using `xdotool getwindowgeometry`
  # and parse the output manually
  geometry=$(xdotool getwindowgeometry "$win_id")
  win_x=$(echo "$geometry" | awk '/Position/ {print $2}' | cut -d, -f1)
  win_y=$(echo "$geometry" | awk '/Position/ {print $2}' | cut -d, -f2)
  win_width=$(echo "$geometry" | awk '/Geometry/ {print $2}' | cut -dx -f1)
  win_height=$(echo "$geometry" | awk '/Geometry/ {print $2}' | cut -dx -f2)

  # Calculate the center of the window
  center_x=$((win_x + win_width / 2))
  center_y=$((win_y + win_height / 2))

  # Move the cursor to the center of the window
  xdotool mousemove "$center_x" "$center_y"
}

line_up
