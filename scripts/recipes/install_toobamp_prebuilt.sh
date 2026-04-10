#!/bin/bash

BASE_URL_DOWNLOAD="https://github.com/rerdavies/ToobAmp/releases/download/v1.1.61"

cd /tmp

wget $BASE_URL_DOWNLOAD/toobamp_1.1.61_arm64.deb
apt-get install ./toobamp_1.1.61_arm64.deb
rm -f toobamp_1.1.61_arm64.deb

