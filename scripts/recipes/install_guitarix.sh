# guitarix.lv2

#install required packages
apt-get -y install libgtk2.0-dev libgtkmm-2.4-dev liblrdf-dev libboost-system-dev \
libzita-convolver-dev libzita-resampler-dev fonts-roboto

#dowload, compile and install guitarix
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone http://git.code.sf.net/p/guitarix/git guitarix-git
cd guitarix-git/trunk
./waf configure --no-lv2-gui --disable-sse --lv2dir=$ZYNTHIAN_PLUGINS_DIR/lv2 --no-avahi --no-bluez --no-faust
./waf build
./waf install
./waf clean
cd ../..
