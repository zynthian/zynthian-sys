#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "x42-plugins" ]; then
	rm -rf "x42-plugins"
fi
mkdir "x42-plugins"

cd $ZYNTHIAN_PLUGINS_SRC_DIR/x42-plugins
git clone https://github.com/x42/robtk.git robtk

PLUGINS=( balance.lv2 controlfilter.lv2 darc.lv2 dpl.lv2 fat1.lv2 fil4.lv2 matrixmixer.lv2 meters.lv2 \
mididebug.lv2 midifilter.lv2 midigen.lv2 midimap.lv2 mixtri.lv2 nodelay.lv2 onsettrigger.lv2 phaserotate.lv2 \
sisco.lv2 spectra.lv2 stepseq.lv2 stereoroute.lv2 testsignal.lv2 xfade.lv2 zconvo.lv2 )

#EXCLUDED PLUGINS=( tuna.lv2 )

MOD=""
#MOD="MOD=1"

for plugin in "${PLUGINS[@]}"; do
	cd $ZYNTHIAN_PLUGINS_SRC_DIR/x42-plugins
	git clone https://github.com/x42/$plugin.git $plugin
	cd $plugin
	sed -i -- 's/-msse -msse2 -mfpmath=sse//' Makefile
	export RW="$ZYNTHIAN_PLUGINS_SRC_DIR/x42-plugins/robtk/"
	make -j 4 $MOD
	rm -rf /usr/local/lib/lv2/$plugin/modgui
	make $MOD install
	make clean
done

rm -rf "$ZYNTHIAN_PLUGINS_SRC_DIR/x42-plugins"

# Install precompiled tuna.lv2 that loads quickly!!
cd /usr/local/lib/lv2/
rm -rf tuna.lv2
wget "$BASE_URL_DOWNLOAD/tuna.lv2.tar.xz"
tar xfv "tuna.lv2.tar.xz"
rm -f "tuna.lv2.tar.xz"

# Install precompiled zeroconvo.lv2 with latest fixes!
cd /usr/local/lib/lv2/
rm -rf zeroconvo.lv2
wget "$BASE_URL_DOWNLOAD/zeroconvo.lv2.tar.xz"
tar xfv "zeroconvo.lv2.tar.xz"
rm -f "zeroconvo.lv2.tar.xz"
