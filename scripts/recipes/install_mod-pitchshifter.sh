# install_mod-pitchshifter.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/moddevices/mod-pitchshifter.git
cd mod-pitchshifter
sed -i -- 's/INSTALLATION_PATH = \$(DESTDIR)\$(INSTALL_PATH)\/\$(EFFECT_PATH)/INSTALLATION_PATH = \/zynthian\/zynthian-plugins\/lv2\/mod-pitchshifter/' Makefile.mk
make -j 4 NOOPT=true
sudo make install
make clean
cd ..
