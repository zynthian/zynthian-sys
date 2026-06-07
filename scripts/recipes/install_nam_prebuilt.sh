#!/bin/bash

VERSION="v0.2.0"
BASE_URL_DOWNLOAD="https://github.com/mikeoliphant/neural-amp-modeler-lv2/releases/download"

cd "$ZYNTHIAN_PLUGINS_DIR/lv2"
if [ -d "Neural_Amp_Modeler.lv2" ]; then
    rm -rf "Neural_Amp_Modeler.lv2"
fi
if [ -d "neural_amp_modeler.lv2" ]; then
    rm -rf "neural_amp_modeler.lv2"
fi
wget "$BASE_URL_DOWNLOAD/$VERSION/neural_amp_modeler_lv2_rpi5.tgz"
wget "$BASE_URL_DOWNLOAD/$VERSION/neural_amp_modeler_lv2_rpi4.tgz"
tar xfvz neural_amp_modeler_lv2_rpi5.tgz
mv neural_amp_modeler.lv2/neural_amp_modeler.so neural_amp_modeler.lv2/neural_amp_modeler_rpi5.so
tar xfvz neural_amp_modeler_lv2_rpi4.tgz
mv neural_amp_modeler.lv2/neural_amp_modeler.so neural_amp_modeler.lv2/neural_amp_modeler_rpi4.so
rm -f neural_amp_modeler_lv2_rpi5.tgz
rm -f neural_amp_modeler_lv2_rpi4.tgz

# Configure binary for the right Pi version
pushd "$ZYNTHIAN_PLUGINS_DIR/lv2/neural_amp_modeler.lv2"
if [[ "$RBPI_VERSION_NUMBER" == "5" ]]; then
    ln -s "neural_amp_modeler_rpi5.so" "neural_amp_modeler.so"
else
    ln -s "neural_amp_modeler_rpi4.so" "neural_amp_modeler.so"
fi
popd
