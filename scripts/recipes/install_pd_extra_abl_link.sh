#!/bin/bash

# Install Pure data extra abl_link~ which allows sync with Ableton Link

cd $ZYNTHIAN_SW_DIR
git clone --recursive https://github.com/libpd/abl_link.git
cd abl_link/external

make -j 4 CFLAGS="-mfpu=neon-fp-armv8 -mneon-for-64bits -mfloat-abi=hard -mvectorize-with-neon-quad"
make install
make clean

cd ../..
