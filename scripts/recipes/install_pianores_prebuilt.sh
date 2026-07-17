#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://github.com/jlearman/PianoRes/releases/download/v0.2.3"
FILE_NAME="PianoRes-v0.2.3-zyn-lv2.zip"
IR_DIR="$ZYNTHIAN_MY_DATA_DIR/files/IRs"

cd $plugins_path
wget "$BASE_URL_DOWNLOAD/$FILE_NAME"
if [ -f "$FILE_NAME" ]; then
	rm -rf ./PianoRes.lv2
	unzip "$FILE_NAME"
	rm -f "$FILE_NAME"
	mv "ImpulseFiles" "$IR_DIR/PianoRes"
	mv "README-zyn-lv2.txt" "PianoRes.lv2"
	# Create soft link to salamander short IR
	ln -s "$IR_DIR/PianoRes/accurate-salamander-grand-6.2-impulse-short.flac" "$IR_DIR/PianoResIR.flac"
fi
