cd $ZYNTHIAN_SW_DIR
if [ ! -d "jack_capture" ]; then
	git clone https://github.com/kmatheussen/jack_capture.git
	cd jack_capture
	make -j 4
	make install
	cd ..
fi
