#!/bin/bash

choice=$(zenity --list \
  --title="Resolution" \
  --column="Select" \
  1920x1200 1600x1200 1280x800 1024x768)

[ -n "$choice" ] && xrandr --output VNC-0 --mode "$choice"
