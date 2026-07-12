# Kill any running instance and wait for it to actually exit before
# relaunching. i3 fires exec_always commands concurrently on every config
# reload, so a bare `killall polybar` in i3 config racing a fresh
# `polybar &` here could let the new instance start while the old one is
# still tearing down its X11/IPC state, causing the bar to silently not
# appear.
killall polybar 2>/dev/null
while pgrep -x polybar >/dev/null; do
  sleep 0.1
done

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload toph &
  done
else
  polybar --reload toph &
fi
