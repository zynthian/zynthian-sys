# rogue
cd $ZYNTHIAN_SW_DIR
sudo apt-get install -y libsamplerate0-dev lvtk-tools
git clone https://github.com/timowest/rogue.git
cd rogue
sed -i -- 's/INSTALL_DIR = \/usr\/local\/lib\/lv2/INSTALL_DIR = \/home\/pi\/zynthian\/zynthian-plugins\/mod-lv2/' Makefile
sed -i -- 's/\$(BUNDLE): manifest.ttl rogue.ttl presets.ttl rogue.so rogue-gui.so presets styles/\$(BUNDLE): manifest.ttl rogue.ttl presets.ttl rogue.so presets styles/' Makefile
make
sudo make install
make clean
cd ..
