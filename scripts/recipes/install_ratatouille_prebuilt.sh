#!/bin/bash

plugins_path = /usr/lib/lv2
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $plugins_path
rm -rf ./Ratatouille.lv2
wget "$BASE_URL_DOWNLOAD/Ratatouille.lv2.tar.xz"
tar xfv Ratatouille.lv2.tar.xz
rm -f Ratatouille.lv2.tar.xz
