#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "ultramaster_kr106"]; then
	rm -rf "ultramaster_kr106"
fi

git clone --recursive https://github.com/kayrockscreenprinting/ultramaster_kr106.git
cd ultramaster_kr106
#make deps     # Install ALSA, X11, freetype, etc. (apt)
#make -j 3 build    # VST3, LV2, Standalone
CONFIG=Release make -j 3 build

# Install LV2 bundle
rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2/Ultramaster KR-106.lv2"
mv "./build-juce/KR106_artefacts/Release/LV2/Ultramaster KR-106.lv2.lv2" $ZYNTHIAN_PLUGINS_DIR/lv2

cd ..
rm -rf "ultramaster_kr106"

