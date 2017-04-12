cd $ZYNTHIAN_SW_DIR
if [ ! -d "touchosc2midi" ]; then
	#apt-get -y install python-pip cython
	git clone https://github.com/velolala/touchosc2midi.git
	cd touchosc2midi
	pip install .
	cd ..
fi
