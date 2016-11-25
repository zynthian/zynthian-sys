# install_gxsupertoneblender.lv2
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/moddevices/GxSuppaToneBender.lv2.git
cd GxSuppaToneBender.lv2
sed -i -- 's/-march=armv7 -mfpu=vfpv3//' Makefile
sed -i -- 's/INSTALL_DIR = \/usr\/lib\/lv2/INSTALL_DIR = \/home\/\pi\/zynthian\/zynthian-plugins\/mod-lv2/' Makefile
make
sudo make install
make clean
cd ..
