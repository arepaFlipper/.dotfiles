#!/bin/bash
current_brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
decrement=$((max_brightness / 10))
new_brightness=$((current_brightness - decrement))
if [ $new_brightness -lt 0 ]; then
  new_brightness=0
fi
echo $new_brightness | sudo tee /sys/class/backlight/intel_backlight/brightness
