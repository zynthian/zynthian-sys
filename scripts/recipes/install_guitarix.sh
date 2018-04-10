# guitarix.lv2

#REQUIRE: libgtk2.0-dev libgtkmm-2.4-dev liblrdf-dev libboost-system-dev libzita-convolver-dev libzita-resampler-dev fonts-roboto

#dowload, compile and install guitarix
cd $ZYNTHIAN_PLUGINS_SRC_DIR

#git clone https://git.code.sf.net/p/guitarix/git guitarix-git
#cd guitarix-git/trunk

wget https://downloads.sourceforge.net/project/guitarix/guitarix/guitarix2-0.36.1.tar.xz
tar xfvJ guitarix2-0.36.1.tar.xz
rm -f guitarix2-0.36.1.tar.xz
cd guitarix-0.36.1

./waf configure --no-lv2-gui --disable-sse --lv2dir=$ZYNTHIAN_PLUGINS_DIR/lv2 --no-avahi --no-bluez --no-faust --no-ladspa
./waf build -j 2
./waf install
./waf clean
cd ../..
