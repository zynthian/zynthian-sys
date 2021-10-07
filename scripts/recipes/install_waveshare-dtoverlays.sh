#!/bin/bash

# Waveshare DT overlays (DTBs)

cd $ZYNTHIAN_SW_DIR
if [ -d "waveshare-dtoverlays" ]; then
	rm -rf "waveshare-dtoverlays"
fi

git clone https://github.com/swkim01/waveshare-dtoverlays.git
cd waveshare-dtoverlays
rm -f /boot/overlays/waveshare*
cp -a *.dtbo /boot/overlays
cp -a waveshare32b.dtb /boot/overlays/waveshare32b.dtbo

