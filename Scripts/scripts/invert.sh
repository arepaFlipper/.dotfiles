#! /bin/bash

if [ "$(pidof pid)" ]; then
	pkill pid
else

	ID=$(xdotool getactivewindow)
	CLASS=$(xprop -id "$ID" | grep "WM_CLASS" | awk '{print $4}')
	COND="class_g=${CLASS}"
	pid --invert-color-include "$COND" &
fi
exit
