# mod-utilities.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/moddevices/mod-utilities.git
cd mod-utilities
sed -i -- 's/^INSTALL_PATH = \/usr\/local\/lib\/lv2/INSTALL_PATH = \/zynthian\/zynthian-plugins\/lv2/' Makefile
make -j 4
sudo make install
make clean
cd ..
