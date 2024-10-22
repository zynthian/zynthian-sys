#!/bin/bash

cd $ZYNTHIAN_SW_DIR
if [ -d "setBfree" ]; then
	rm -rf "setBfree"
fi

git clone https://github.com/pantherb/setBfree.git
cd setBfree
./localize_rtk.sh
mkdir lv2

sed -i -- "s/-msse -msse2 -mfpmath=sse/$CFLAGS $CFLAGS_UNSAFE/g" common.mak
sed -i -- "s|^lv2dir = \$(PREFIX)/lib/lv2|lv2dir = $ZYNTHIAN_SW_DIR/setBfree/lv2|" common.mak

make -j 4
make install
#cp -a lv2/b_synth $ZYNTHIAN_PLUGINS_DIR/lv2/b_synth.lv2
cp -a lv2/b_whirl $ZYNTHIAN_PLUGINS_DIR/lv2/b_whirl.lv2

# make b_whirl_mod
#make clean
#MOD=true make -j 4
#cp -a lv2/b_whirl $ZYNTHIAN_PLUGINS_DIR/lv2/b_whirl_mod.lv2

cd ..
#rm -rf "setBfree"
