#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $ZYNTHIAN_PLUGINS_DIR/lv2

if [ -d "TAL-U-NO-LX-V2.lv2" ]; then
	rm -rf "TAL-U-NO-LX-V2.lv2"
fi
wget "$BASE_URL_DOWNLOAD/TAL-U-NO-LX-V2.lv2.tar.xz"
tar xfv "TAL-U-NO-LX-V2.lv2.tar.xz"
rm -f "TAL-U-NO-LX-V2.lv2.tar.xz"
