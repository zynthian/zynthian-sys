#!/bin/bash

# fluidsynth
cd $ZYNTHIAN_SW_DIR

SW_DIR="fluidsynth"
if [ -d "$SW_DIR" ]; then
	rm -rf "$SW_DIR"
fi

#git clone https://github.com/FluidSynth/fluidsynth.git
#git clone --branch v2.1.0 https://github.com/FluidSynth/fluidsynth.git $SW_DIR
git clone --branch v2.0.9 https://github.com/FluidSynth/fluidsynth.git $SW_DIR
cd $SW_DIR
mkdir build
cd build
cmake .. -Denable-alsa=0 -Denable-aufile=0 -Denable-oss=0 -Denable-pulseaudio=0 -Denable-ladspa=0 -Denable-lash=0 -Denable-floats=1 
# Debugging ...
#-Denable-ubsan=1 -Denable-debug=1 -fsanitize=address
#-Denable-fpe-check=0  -Denable-dbus=1
make -j 4
make install
ldconfig

cd ../..
rm -rf "$SW_DIR"
