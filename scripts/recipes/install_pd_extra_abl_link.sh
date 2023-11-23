#!/bin/bash

# Install Pure data extra abl_link~ which allows sync with Ableton Link

# Override compiler flags.
if [ ${MACHINE_HW_NAME} = "armv7l" ]; then
	export CFLAGS="-mfpu=neon-fp-armv8 -mneon-for-64bits -mfloat-abi=hard -mvectorize-with-neon-quad"
elif [ ${MACHINE_HW_NAME} = "aarch64" ]; then
	export CFLAGS="-mcpu=cortex-a72 -mtune=cortex-a72"
fi

cd $ZYNTHIAN_SW_DIR
git clone --recursive https://github.com/libpd/abl_link.git
cd abl_link/external

make -j 4
make install
make clean

cd ../..
