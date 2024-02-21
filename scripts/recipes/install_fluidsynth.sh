#!/bin/bash

# fluidsynth
cd $ZYNTHIAN_SW_DIR

if [ -d "fluidsynth" ]; then
	rm -rf "fluidsynth"
fi

#git clone https://github.com/FluidSynth/fluidsynth.git
#git clone --branch v2.1.4 https://github.com/FluidSynth/fluidsynth.git
git clone --branch v2.0.9 https://github.com/FluidSynth/fluidsynth.git
cd fluidsynth
mkdir build
cd build
cmake .. -Denable-alsa=0 -Denable-aufile=0 -Denable-oss=0 -Denable-pulseaudio=0 -Denable-ladspa=0 -Denable-lash=0 -Denable-floats=1 

# Debug build ...
# apt install libubsan0 libasan5
#export CMAKE_CXX_FLAGS_DEBUG="${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address"
#export CMAKE_LINKER_FLAGS_DEBUG="${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address"
#cmake .. -Denable-alsa=0 -Denable-aufile=0 -Denable-oss=0 -Denable-pulseaudio=0 -Denable-ladspa=0 -Denable-lash=0 -Denable-floats=1 -Denable-ubsan=1 -Denable-debug=1
# -fsanitize=address
#-Denable-fpe-check=0  -Denable-dbus=1
# Debug Run
# export LD_PRELOAD=/usr/lib/gcc/arm-linux-gnueabihf/8/libasan.so;
#/usr/local/bin/fluidsynth -p fluidsynth -a jack -m jack -g 1 -j -o synth.midi-bank-select=mma -o synth.cpu-cores=3 -o synth.polyphony=64

make -j 4
make install
# We remove it!!! Yessss! This is for uninstalling previously "installed from source" version.
# We want the debian repo version!!
make uninstall
ldconfig

cd ../..
rm -rf "fluidsynth"
