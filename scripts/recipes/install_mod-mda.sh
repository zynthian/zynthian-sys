#!/bin/bash

# mod-mda.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "mda-lv2" ]; then
	rm -rf "mda-lv2"
fi

git clone https://github.com/mod-audio/mda-lv2
cd mda-lv2
sed -i "s/rU/r/g" .waf3-1.7.16-298c23e5260e502b06df5657cfb0eb26/waflib/Context.py
sed -i "s/rU/r/g" .waf3-1.7.16-298c23e5260e502b06df5657cfb0eb26/waflib/ConfigSet.py
./waf configure
./waf configure --lv2-user --lv2dir=$ZYNTHIAN_PLUGINS_DIR/lv2
./waf build
./waf -j1 install
./waf clean
cd ..

rm -rf "mda-lv2"