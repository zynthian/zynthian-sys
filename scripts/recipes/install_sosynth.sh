# sosynth.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/jeremysalwen/So-synth-LV2
cd So-synth-LV2
sed -i -- 's/^INSTALLDIR = \$(DESTDIR)\/usr\/lib\/lv2\//INSTALLDIR = \/zynthian\/zynthian-plugins\/lv2\//' Makefile
make -j 4
sudo make install
make clean
