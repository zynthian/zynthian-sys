#!/bin/bash

BASE_URL_DOWNLOAD="https://github.com/PatttF/zynMI/releases/download/BraidsPlaits/zynMI.zip"

rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/mi_braids.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/mi_plaits.lv2

wget "$BASE_URL_DOWNLOAD"
unzip zynMI.zip
mv zynMI/braids.lv2 mi_braids.lv2
mv zynMI/plaits.lv2 mi_plaits.lv2
mv zynMI/*.lv2 .
rm -rf zynMI
rm -fzynMI.zip
