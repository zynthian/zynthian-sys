# install_sooperlooper-lv2-plugin.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/moddevices/sooperlooper-lv2-plugin.git
cd sooperlooper-lv2-plugin/sooperlooper
sed -i -- 's/INSTALLATION_PATH = \$(DESTDIR)\$(INSTALL_PATH)\/\$(PLUGIN).lv2\//INSTALLATION_PATH = \/zynthian\/zynthian-plugins\/lv2\/sooperlooper.lv2/' Makefile
make -j 4
sudo make install
make clean
cd ..
