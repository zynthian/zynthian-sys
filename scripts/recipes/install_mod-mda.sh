# mod-mda.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/moddevices/mda-lv2.git
cd mda-lv2
./waf configure --lv2-user --lv2dir=$ZYNTHIAN_PLUGINS_DIR/lv2
./waf build
sudo ./waf -j1 install
./waf clean
cd ..
