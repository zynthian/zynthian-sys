# install_mod-caps.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/moddevices/caps-lv2.git
cd caps-lv2
make -j 4
sudo cp -R plugins/* $ZYNTHIAN_PLUGINS_DIR/lv2
make clean
cd ..
