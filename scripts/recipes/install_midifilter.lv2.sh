# midifilter.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/x42/midifilter.lv2.git
cd midifilter.lv2
sed -i -- 's/-msse -msse2 -mfpmath=sse/-march=armv6/' Makefile
sed -i -- 's/LV2DIR ?= \$(PREFIX)\/lib\/lv2/LV2DIR ?= \/zynthian\/zynthian-plugins\/lv2/' Makefile
make -j 4
sudo make install
make clean
cd ..
