#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"

VERSION="1.3.1"
DIRNAME="riban-lv2_${VERSION}"
FILENAME="riban-lv2_${VERSION}_arm64.tar.gz"
URL_DOWNLOAD="https://github.com/riban-bw/lv2-plugins/releases/download/${VERSION}/${FILENAME}"
#DIRNAME="riban-lv2"
#FILENAME="riban-lv2.tar.xz"
#URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64/${FILENAME}"

cd $plugins_path
wget "$URL_DOWNLOAD"

rm -rf ./riban*.lv2
tar xfvz "${FILENAME}"

#tar xfv "${FILENAME}"
#mv ./${DIRNAME}/* .
#rm -rf "${DIRNAME}"

rm -f "${FILENAME}"


