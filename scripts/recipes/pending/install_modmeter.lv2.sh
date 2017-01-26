# midifilter.lv2
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/x42/modmeter.lv2.git
cd modmeter.lv2
sed -i -- 's/-msse -msse2 -mfpmath=sse //' Makefile
sed -i -- 's/LV2DIR ?= \$(PREFIX)\/\$(LIBDIR)\/lv2/LV2DIR ?= \/home\/pi\/zynthian\/zynthian-plugins\/mod-lv2/' Makefile
make MOD=1
sudo make install MOD=1
make clean
cd ..
