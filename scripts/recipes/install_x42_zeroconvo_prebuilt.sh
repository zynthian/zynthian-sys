#!/bin/bash

plugins_path="/usr/local/lib/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $plugins_path
rm -rf ./zeroconvo.lv2
wget "$BASE_URL_DOWNLOAD/zeroconvo.lv2.tar.xz"
tar xfv zeroconvo.lv2.tar.xz
rm -f zeroconvo.lv2.tar.xz
