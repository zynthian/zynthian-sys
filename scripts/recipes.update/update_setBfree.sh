
cd $ZYNTHIAN_SW_DIR/setBfree
git checkout .
git pull | grep -q -v 'Already up.to.date.' && changed=1
if [ "$changed" -eq 1 ]; then
	sed -i -- "s/-msse -msse2 -mfpmath=sse/$CFLAGS $CFLAGS_UNSAFE/g" common.mak
	sed -i -- 's/^lv2dir = \$(PREFIX)\/lib\/lv2/lv2dir = \/zynthian\/zynthian-plugins\/lv2/' common.mak
	make clean
	make -j 3
	make install
fi
cd ..
