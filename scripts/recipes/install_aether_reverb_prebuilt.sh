#!/bin/bash

BASE_URL_DOWNLOAD="https://github.com/PatttF/zynMI/releases/download/BraidsPlaitsMarbles"

cd $ZYNTHIAN_PLUGINS_DIR/lv2
rm -rf ./Aether.lv2
wget "$BASE_URL_DOWNLOAD/Aether-arm64.zip"
unzip Aether-arm64.zip
rm Aether-arm64.zip
