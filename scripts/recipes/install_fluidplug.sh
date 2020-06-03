#!/bin/bash

# fluidplug
cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "FluidPlug" ]; then
	rm -rf "FluidPlug"
fi

#git clone https://github.com/falkTX/FluidPlug.git
git clone https://github.com/zynthian/FluidPlug.git
cd FluidPlug/
sed -i -- 's/-ffast-math -mtune=generic -msse -msse2 -mfpmath=sse -fdata-sections -ffunction-sections//' Makefile.mk
sed -i -- 's/-msse -msse2//' Makefile.mk
sed -i -- 's/^DESTDIR =/DESTDIR =\/zynthian\/zynthian-plugins/' Makefile
sed -i -- 's/^PREFIX  = \/usr//' Makefile
sed -i -- 's/\$(PREFIX)\/lib//' Makefile

make -j 4
make install
ldconfig
make distclean

cd ..
rm -rf "FluidPlug"
