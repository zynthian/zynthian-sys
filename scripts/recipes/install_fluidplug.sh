# fluidplug
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/falkTX/FluidPlug.git
cd FluidPlug/
sed -i -- 's/-ffast-math -mtune=generic -msse -msse2 -mfpmath=sse -fdata-sections -ffunction-sections/-march=armv6/' Makefile.mk
sed -i -- 's/-msse -msse2/-march=armv6/' Makefile.mk
sed -i -- 's/^DESTDIR =/DESTDIR =\/zynthian\/zynthian-plugins/' Makefile
sed -i -- 's/^PREFIX  = \/usr//' Makefile
sed -i -- 's/\$(PREFIX)\/lib//' Makefile
#cp $ZYNTHIAN_RECIPE_DIR/FluidPlug.Makefile .
#make -f FluidPlug.Makefile
make -j 4
#sudo make -f FluidPlug.Makefile install
sudo make install
sudo ldconfig
make distclean
cd ..
