#!/bin/bash

# Turn On Display Backlight
function backlight_on() {
	if [ -f /sys/class/backlight/*/bl_power ]; then
		echo 0 > /sys/class/backlight/*/bl_power
	fi
}

# Turn Off Display Backlight
function backlight_off() {
	if [ -f /sys/class/backlight/*/bl_power ]; then
		echo 1 > /sys/class/backlight/*/bl_power
	fi
}

if [[ -z "$DISPLAY" ]]; then
	export DISPLAY=:0
fi

case $1 in
	on)
		xset dpms force off
		xset s off
		backlight_off
		cpufreq-set -g powersave
		;;
	off)
		cpufreq-set -g performance
		xset dpms force on
		xset dpms 0 0 100000000
		xset s off
		backlight_on
		;;
  *)
 		echo "Use: powersave_control.sh on|off"
 		;;
esac
