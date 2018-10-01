#!/bin/bash

# fluidsynth
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/FluidSynth/fluidsynth.git
cd fluidsynth
mkdir build
cd build
cmake .. -Denable-alsa=0 -Denable-aufile=0 -Denable-oss=0 -Denable-pulseaudio=0 -Denable-ladspa=0 -Denable-lash=0 -Denable-floats=1 
#-Denable-fpe-check=0  -Denable-dbus=1
make -j 4
make install
ldconfig
cd ../..
