
cd $ZYNTHIAN_PLUGINS_SRC_DIR/dexed
git pull origin native-lv2
cd src
make
sudo make install
cd ../..
