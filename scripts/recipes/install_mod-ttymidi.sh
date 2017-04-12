cd $ZYNTHIAN_SW_DIR
if [ ! -d "mod-ttymidi" ]; then
	git clone https://github.com/moddevices/mod-ttymidi.git
	cd mod-ttymidi
	make -j 4
	make install
	cd ..
fi
