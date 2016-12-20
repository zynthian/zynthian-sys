cd $ZYNTHIAN_SW_DIR
git clone https://github.com/pantherb/setBfree.git
cd setBfree
sed -i -- "s/-msse -msse2 -mfpmath=sse/$CFLAGS $CFLAGS_UNSAFE/g" common.mak
sed -i -- 's/^lv2dir = \$(PREFIX)\/lib\/lv2/lv2dir = \/zynthian\/zynthian-plugins\/lv2/' common.mak
make -j 4
make install
