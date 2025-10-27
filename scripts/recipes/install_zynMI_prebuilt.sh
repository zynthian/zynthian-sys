#!/bin/bash

BASE_URL_DOWNLOAD="https://github.com/PatttF/zynMI/releases/download/BraidsPlaits"

cd $ZYNTHIAN_PLUGINS_DIR/lv2
if [ -d "./zynMI" ]; then
	rm -rf ./zynMI
fi
if [ -d "./mi_braids.lv2" ]; then
	rm -rf ./mi_braids.lv2
fi
if [ -d "./mi_plaits.lv2" ]; then
	rm -rf ./mi_plaits.lv2
fi
if [ -d "./mi_marbles.lv2" ]; then
	rm -rf ./mi_marbles.lv2
fi
mkdir zynMI
cd zynMI
wget "$BASE_URL_DOWNLOAD/zynMI.zip"
unzip zynMI.zip
cd ..
mv zynMI/*.lv2 .
rm -rf zynMI
