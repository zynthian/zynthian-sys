#!/bin/bash

cd $ZYNTHIAN_SW_DIR
rm -rf setBfree
git clone https://github.com/pantherb/setBfree.git
cd setBfree
mkdir lv2

sed -i -- "s/-msse -msse2 -mfpmath=sse/$CFLAGS $CFLAGS_UNSAFE/g" common.mak
sed -i -- "s|^lv2dir = \$(PREFIX)/lib/lv2|lv2dir = $ZYNTHIAN_SW_DIR/setBfree/lv2|" common.mak

# First, make b_whirl_mod
MOD=true make -j 4
MOD=true make install
mv lv2/b_whirl lv2/b_whirl_mod

# Now make b_whirl
make clean
make -j 4
make install

# Split extended into b_whirl_xt
cp -r lv2/b_whirl lv2/b_whirl_xt
rm lv2/b_whirl/b_whirl-configurable.ttl
rm lv2/b_whirl_xt/b_whirl.ttl

cp -r lv2/* /zynthian/zynthian-plugins/lv2/
