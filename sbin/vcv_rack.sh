#!/bin/bash

export DISPLAY=:100
xpra start-desktop $DISPLAY --start-child="$ZYNTHIAN_SW_DIR/vcvrack.raspbian-v1/Rack -d" --exit-with-children --xvfb="Xorg :10 vt7 -auth .Xauthority -config xrdp/xorg.conf -noreset -nolisten tcp" --start-via-proxy=no --systemd-run=no --file-transfer=no --printing=no --resize-display=no --mdns=no --pulseaudio=no --dbus-proxy=no --dbus-control=no --webcam=no --notifications=no