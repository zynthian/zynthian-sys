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

case $1 in
	on)
		backlight_on
		;;
	off)
		backlight_off
		;;
  *)
 		echo "Use: backlight_control on|off"
 		;;
esac
