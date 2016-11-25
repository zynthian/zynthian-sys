# guitarix.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone http://git.code.sf.net/p/guitarix/git guitarix-git
cd guitarix-git/trunk
./waf configure --no-lv2-gui --lv2-only --disable-sse --lv2dir=$ZYNTHIAN_PLUGINS_DIR/lv2 --no-avahi --no-bluez --no-ladspa --no-faust 
./waf build
sudo ./waf install
./waf clean
cd ../..
