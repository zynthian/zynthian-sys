#!/bin/bash

# Adjust Compiler options
if [ ${MACHINE_HW_NAME} = "armv7l" ]; then
	if [[ ${RBPI_VERSION} =~ [2] ]]; then
		export CFLAGS="-O3 -ffast-math -ftree-vectorize -mcpu=cortex-a7 -mtune=cortex-a7 -mfpu=neon-vfpv4 $CFLAGS_UNSAFE"
	else
		export CFLAGS="-O3 -ffast-math -ftree-vectorize -mcpu=cortex-a53 -mtune=cortex-a53 -mfpu=neon-fp-armv8 $CFLAGS_UNSAFE"
	fi
else
	export CFLAGS="-O3 -ffast-math -ftree-vectorize $CFLAGS_UNSAFE"
fi

# Install Faust code (v 0.9.73)
cd $ZYNTHIAN_SW_DIR
git clone --single-branch -b 0.9.73-mr2 https://github.com/grame-cncm/faust.git faust-0.9.73
cd faust-0.9.73/architecture/faust/audio
ln -s ../dsp/dsp.h .

# Build foo-yc20 combo-organ emulator
cd $ZYNTHIAN_SW_DIR
#git clone https://github.com/sampov2/foo-yc20.git
git clone https://github.com/zynthian/foo-yc20.git
cd foo-yc20
sed -i -- 's/\-Iinclude\//\-Iinclude\/ \-I\.\.\/faust\-0\.9\.73\/architecture\//' Makefile
sed -i -- 's/NULL/0/' src/faust-dsp-standalone.cpp
sed -i -- 's/NULL/0/' src/faust-dsp-plugin.cpp
make -j 1
make install
make clean

