#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "x42-avldrums" ]; then
	rm -rf "x42-avldrums"
fi

package=x42-avldrums-v0.7.3-arm64
wget "https://x42-plugins.com/x42/linux/$package.tar.gz"
tar xfvz "$package.tar.gz"
mv x42-avldrums/avldrums.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

rm -rf "x42-avldrums"
