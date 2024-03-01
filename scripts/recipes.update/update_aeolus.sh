
cd $ZYNTHIAN_SW_DIR

build_aeolus=0
if [ ! -d "aeolus" ]; then
	git clone https://github.com/riban-bw/aeolus.git
	cd aeolus
	git checkout zynthian
	build_aeolus=1
else
	cd aeolus
	git checkout .
	git pull | grep -q -v 'Already up to date.' && build_aeolus=1
fi
if [ "$build_aeolus" == "1" ]; then
	cd source
	make clean
	make -j 3
	make install
	cd ..
fi
cd ..

