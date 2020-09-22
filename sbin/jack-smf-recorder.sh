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

if [ -z "$1" ]; then
	jport="ZynMidiRouter:main_out"
else
	jport=$1
fi

if [ -z "$2" ]; then
	# Get filename (next in sequence) to use ...
	if [ -z "$(ls jack_capture_*.mid)" ]; then
		fname=jack_capture_01
	else
		last_fname=$(ls jack_capture_*.mid | tail -1)
		last_fname=${last_fname%.mid}
		fname=`echo $last_fname | awk -F'[^0-9]+' 'sub($NF"$",sprintf("%0*d",length($NF),$NF+1))'`
	fi
	fname=$fname.mid
else
	fname=$2
fi

# Capture MIDI using jack-smf-recorder
/usr/local/bin/jack-smf-recorder -a $jport "$fname"

# Write buffers to disk
sync
