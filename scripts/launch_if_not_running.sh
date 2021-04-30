#!/bin/sh

pid=$(pgrep $1)
if [ " $pid " = "  " ]
then
    $@ &
else
    window=$(xdotool search --pid $pid | tail -n 1)
	active_window=$(xdotool getactivewindow)
	if [ $active_window -eq $window ]
	then
		xdotool windowminimize $window
	else
		xdotool windowactivate $window
	fi
fi
