#!/bin/bash

# Install DISTRHO DPF plugins

cd $ZYNTHIAN_PLUGINS_SRC_DIR

# Get source code
git clone https://github.com/DISTRHO/DPF-Plugins.git
cd DPF-Plugins

# Avoid errors while installing binaries
sed -i -- 's/cp \-r bin\/ProM/\#cp \-r bin\/ProM/' Makefile
sed -i -- 's/cp \-r bin\/glBars/\#cp \-r bin\/glBars/' Makefile

# Build
export NOOPT=true
make -j 3
make install
make clean

# Create symlinks in zynthian plugins dir
LV2_LOCAL_DIR=/usr/local/lib/lv2
PLUGINS=( 3BandEQ 3BandSplitter AmplitudeImposer CycleShifter Kars MVerb MaBitcrush MaFreeverb MaGigaverb MaPitchshift Nekobi PingPongPan ProM )

for u in "${PLUGINS[@]}"; do
	#Remove pre-existing plugin
	rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/$u.lv2
	#Create symlinks to LV2
	ln -s $LV2_LOCAL_DIR/$u.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
done
