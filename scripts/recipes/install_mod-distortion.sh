# install_mod-distortion.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/moddevices/mod-distortion.git
cd mod-distortion
make -j 4
sudo make INSTALL_PATH=$ZYNTHIAN_PLUGINS_DIR/lv2 install
make clean
cd ..
