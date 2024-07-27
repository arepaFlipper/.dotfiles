#!/bin/bash
max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
current_brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
increment=$((max_brightness / 10))
new_brightness=$((current_brightness + increment))
if [ $new_brightness -gt $max_brightness ]; then
  new_brightness=$max_brightness
fi
echo $new_brightness | sudo tee /sys/class/backlight/intel_backlight/brightness
