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
#wget "$BASE_URL_DOWNLOAD/mi_mutated-arm64.zip"
unzip zynMI.zip
#unzip mi_mutated-arm64.zip
cd ..
mv zynMI/*.lv2 .
rm -rf zynMI
