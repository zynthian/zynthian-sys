# drmr.lv2
cd $ZYNTHIAN_SW_DIR
sudo apt-get install -y samplerate-dev 
git clone https://github.com/nicklan/drmr.git
cd drmr
# <BEGIN HACK> The following lines are a f***ing b***sh*t hack - only needed if no X-dev is installed
# Kids: Don't do this at home!!! :-)
sudo apt-get --download-only install -y libgtk-3-dev
sudo dpkg -i --ignore-depends=libgtk-3-0,gir1.2-gtk-3.0,libgtk-3-common,dconf-gsettings-backend,libgdk-pixbuf2.0-dev,libpango1.0-dev,libatk1.0-dev,libatk-bridge2.0-dev,libcairo2-dev,libx11-dev,libxext-dev,libxinerama-dev,libxi-dev,libxrandr-dev,libxcursor-dev,libxfixes-dev,libxcomposite-dev,libxdamage-dev,libwayland-dev,libxkbcommon-dev /var/cache/apt/archives/libgtk-3-dev_3.14.5-1+deb8u1rpi1rpi1g_armhf.deb
sudo rm /var/cache/apt/archives/*.deb
# <END OF HACK>
mkdir build
cd build
cmake ..


sed -i -- 's/-msse -msse2 -mfpmath=sse //' Makefile
sed -i -- 's/LV2DIR ?= \$(PREFIX)\/$(LIBDIR)\/lv2/LV2DIR ?= \/home\/pi\/zynthian\/zynthian-plugins\/mod-lv2/' Makefile
make
sudo make install
sudo cp -R modgui /home/pi/zynthian/zynthian-plugins/mod-lv2/mclk.lv2
cat <<EOF >>/home/pi/zynthian/zynthian-plugins/lv2/mclk.lv2/manifest.ttl
<http://gareus.org/oss/lv2/mclk>
    modgui:gui [
        modgui:resourcesDirectory <modgui> ;
        modgui:iconTemplate <modgui/icon-mclk.html> ;
        modgui:stylesheet <modgui/stylesheet-mclk.css> ;
        modgui:screenshot <modgui/screenshot-mclk.png> ;
        modgui:thumbnail <modgui/thumbnail-mclk.png> ;
        modgui:brand "x42" ;
        modgui:label "MIDI Clock" ;
        modgui:port [
            lv2:index 0 ;
            lv2:symbol "mode" ;
            lv2:name "Mode" ;
        ] ;
    ] .
EOF
make clean
