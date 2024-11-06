# qmidiarp

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "qmidiarp" ]; then
	rm -rf "qmidiarp"
fi

git clone --recursive https://github.com/emuse/qmidiarp.git
#git clone https://github.com/zynthian/qmidiarp.git
cd qmidiarp

autoreconf -i
sed -i -- "s/-msse -msse2 -mfpmath=sse/$CFLAGS $CFLAGS_UNSAFE/g" configure
sed -i -- "s/-msse -msse2 -mfpmath=sse/$CFLAGS $CFLAGS_UNSAFE/g" configure.ac
./configure --enable-lv2plugins
make -j 3
make install
cd ..

rm -rf "qmidiarp"
