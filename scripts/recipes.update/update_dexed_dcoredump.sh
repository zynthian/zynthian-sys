
cd $ZYNTHIAN_PLUGINS_SRC_DIR/dexed
git pull origin native-lv2
cd src
make clean
make
sudo make install
rm -r /zynthian/zynthian-my-plugins/lv2/dexed_*.lv2
cd ../..
