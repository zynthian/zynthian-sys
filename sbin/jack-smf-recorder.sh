#!/bin/bash

# Configure capture directory
if mountpoint -q -- "/media/usb0"; then
	CAPTURE_DIR="/media/usb0"
	echo "Capturing MIDI to USB storage => $CAPTURE_DIR"
else
	CAPTURE_DIR="/zynthian/zynthian-my-data/capture"
	if [ ! -d "$CAPTURE_DIR" ]; then
		mkdir $CAPTURE_DIR
	fi
	echo "Capturing MIDI to internal storage => $CAPTURE_DIR"
fi

cd $CAPTURE_DIR

# Get filename (next in sequence) to use ...
if [ -z "$(ls jack_capture_*.mid)" ]; then
	fname=jack_capture_01
else
	last_fname=$(ls jack_capture_*.mid | tail -1)
	last_fname=${last_fname%.mid}
	fname=`echo $last_fname | awk -F'[^0-9]+' 'sub($NF"$",sprintf("%0*d",length($NF),$NF+1))'`
fi

# Capture MIDI using jack-smf-recorder
/usr/local/bin/jack-smf-recorder -a ZynMidiRouter:main_out $fname.mid

# Write buffers to disk
sync
