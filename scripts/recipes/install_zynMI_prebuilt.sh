#!/bin/bash

BASE_URL_DOWNLOAD="https://github.com/PatttF/zynMI/releases/download/BraidsPlaitsMarbles"

cd $ZYNTHIAN_PLUGINS_DIR/lv2
if [ -d "./zynMI" ]; then
	rm -rf ./zynMI
fi
rm -rf ./mi_*.lv2
mkdir zynMI
cd zynMI
wget "$BASE_URL_DOWNLOAD/zynMI.zip"
unzip zynMI.zip
cd ..
mv zynMI/*.lv2 .
rm -rf zynMI
