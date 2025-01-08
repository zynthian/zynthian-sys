#!/bin/bash

nam_lv2_path="$ZYNTHIAN_PLUGINS_DIR/lv2/Neural_Amp_Modeler.lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

rm -rf $nam_lv2_path
cd $ZYNTHIAN_PLUGINS_DIR/lv2
wget "$BASE_URL_DOWNLOAD/Neural_Amp_Modeler.lv2.tar.xz"
tar xfv Neural_Amp_Modeler.lv2.tar.xz
rm -f Neural_Amp_Modeler.lv2.tar.xz
