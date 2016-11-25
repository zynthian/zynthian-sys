# dx.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/dcoredump/deeaxe7.lv2.git
cd deeaxe7.lv2/src
make
sudo make install
make clean
cd ../..
