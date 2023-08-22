#!/bin/bash

# Install Hylia - Host transport library for Ableton Link

# Override compiler flags.
if [ ${MACHINE_HW_NAME} = "armv7l" ]; then
	export CFLAGS="-mfpu=neon-fp-armv8 -mneon-for-64bits -mfloat-abi=hard -mvectorize-with-neon-quad"
elif [ ${MACHINE_HW_NAME} = "aarch64" ]; then
	export CFLAGS="-mcpu=cortex-a72 -mtune=cortex-a72"
fi
export CXXFLAGS=$CFLAGS
export NOOPT=true

cd $ZYNTHIAN_SW_DIR
git clone --recursive https://github.com/falkTX/Hylia.git
cd Hylia

make -j 4
make install
make clean

cd ..
