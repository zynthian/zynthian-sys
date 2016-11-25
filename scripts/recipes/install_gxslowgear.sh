# install_gxslowgear.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/moddevices/GxSlowGear.lv2.git
cd GxSlowGear.lv2/
sed -i -- 's/-msse2 -mfpmath=sse/-march=armv6/' Makefile
sed -i -- 's/INSTALL_DIR = \/usr\/lib\/lv2/INSTALL_DIR = \/zynthian\/zynthian-plugins\/lv2/' Makefile
make -j 4
sudo make install
make clean
cd ..
