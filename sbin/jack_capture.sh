#!/bin/bash

if mountpoint -q -- "/media/usb0"; then
	CAPTURE_DIR="/media/usb0"
	echo "Capturing to USB storage => $CAPTURE_DIR"
else
	CAPTURE_DIR="/zynthian/zynthian-my-data/capture"
	if [ ! -d "$CAPTURE_DIR" ]; then
		mkdir $CAPTURE_DIR
	fi
	echo "Capturing to internal storage => $CAPTURE_DIR"
fi

cd $CAPTURE_DIR

if [ $1 = "--zui" ]; then
	jack_capture --no-stdin --absolutely-silent --jack-transport
else
	jack_capture
fi

