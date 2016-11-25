# mclk.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/x42/mclk.lv2.git
cd mclk.lv2
sed -i -- 's/-msse -msse2 -mfpmath=sse/-march=armv6/' Makefile
sed -i -- 's/LV2DIR ?= \$(PREFIX)\/$(LIBDIR)\/lv2/LV2DIR ?= \/zynthian\/zynthian-plugins\/lv2/' Makefile
make -j 4
sudo make install
sudo cp -R modgui $ZYNTHIAN_PLUGINS_DIR/lv2/mclk.lv2
cat <<EOF >>$ZYNTHIAN_PLUGINS_DIR/lv2/mclk.lv2/manifest.ttl
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
