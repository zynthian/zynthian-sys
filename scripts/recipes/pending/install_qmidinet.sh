# qmidinet
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone http://git.code.sf.net/p/qmidinet/code qmidinet-git
cd qmidinet-git
./autogen.sh
./configure

make
sudo make install
cd ../..