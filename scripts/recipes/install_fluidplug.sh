#!/bin/bash

# fluidplug
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/falkTX/FluidPlug.git
cd FluidPlug/
sed -i -- 's/-ffast-math -mtune=generic -msse -msse2 -mfpmath=sse -fdata-sections -ffunction-sections//' Makefile.mk
sed -i -- 's/-msse -msse2//' Makefile.mk
sed -i -- 's/^DESTDIR =/DESTDIR =\/zynthian\/zynthian-plugins/' Makefile
sed -i -- 's/^PREFIX  = \/usr//' Makefile
sed -i -- 's/\$(PREFIX)\/lib//' Makefile
#cp $ZYNTHIAN_RECIPE_DIR/FluidPlug.Makefile .

#Avoid using FluidSynth v2, installed in /usr/local:
export C_INCLUDE_PATH="/usr/include:/usr/local/include"
#mv /usr/local/include/fluidsynth.h /usr/local/include/fluidsynth2.h

#make -f FluidPlug.Makefile
make -j 4
#sudo make -f FluidPlug.Makefile install
sudo make install
sudo ldconfig
make distclean
cd ..
