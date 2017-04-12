cd $ZYNTHIAN_SW_DIR
if [ ! -d "jack_capture" ]; then
	git clone https://github.com/kmatheussen/jack_capture.git
	make -j 4
	make install
	cd ..
fi
