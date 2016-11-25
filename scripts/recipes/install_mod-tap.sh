# install_mod-tap.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/moddevices/tap-lv2.git
cd tap-lv2
sed -i -- 's/-mtune=generic -msse -msse2 -mfpmath=sse/-march=armv6/' Makefile.mk
make -j 4
sudo make INSTALL_PATH=$ZYNTHIAN_PLUGINS_DIR/lv2
make clean
cd ..
