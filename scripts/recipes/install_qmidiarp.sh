# qmidiarp

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "qmidiarp" ]; then
	rm -rf "qmidiarp"
fi

git clone https://github.com/emuse/qmidiarp.git
cd qmidiarp

autoreconf -i
./configure --enable-lv2plugins
make -j 3
make install
cd ..

rm -rf "qmidiarp"
