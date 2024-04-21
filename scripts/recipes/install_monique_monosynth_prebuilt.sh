#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd /usr/local/lib/lv2

wget "$BASE_URL_DOWNLOAD/MoniqueMonosynth.lv2.tar.xz"
tar xfv "MoniqueMonosynth.lv2.tar.xz"
rm "MoniqueMonosynth.lv2.tar.xz"

