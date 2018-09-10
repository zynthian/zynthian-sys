#!/bin/bash

# Configure capture directory
if mountpoint -q -- "/media/usb0"; then
	CAPTURE_DIR="/media/usb0"
	echo "Capturing Audio to USB storage => $CAPTURE_DIR"
else
	CAPTURE_DIR="/zynthian/zynthian-my-data/capture"
	if [ ! -d "$CAPTURE_DIR" ]; then
		mkdir $CAPTURE_DIR
	fi
	echo "Capturing Audio to internal storage => $CAPTURE_DIR"
fi

# Capture audio using jack_capture
cd $CAPTURE_DIR
if [ $1 = "--zui" ]; then
	/usr/local/bin/jack_capture --no-stdin --absolutely-silent --jack-transport
else
	/usr/local/bin/jack_capture
fi

# Write buffers to disk
sync
