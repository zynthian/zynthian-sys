#!/bin/bash

# Install Hylia - Host transport library for Ableton Link

# Keep original CFLAGS
ZYNTHIAN_CFLAGS=$CFLAGS
ZYNTHIAN_CXXFLAGS=$CXXFLAGS

# Override compiler flags.
export CFLAGS="-mfpu=neon-fp-armv8 -mneon-for-64bits -mfloat-abi=hard -mvectorize-with-neon-quad"
export CXXFLAGS="-mfpu=neon-fp-armv8 -mneon-for-64bits -mfloat-abi=hard -mvectorize-with-neon-quad"
export NOOPT=true

cd $ZYNTHIAN_SW_DIR
git clone --recursive https://github.com/falkTX/Hylia.git
cd Hylia

make -j 4
make install
make clean

cd ..
