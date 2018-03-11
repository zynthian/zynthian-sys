

# 2017-11-21 => tornadostreamform, required by zynthian-webconf
res=`pip3 show tornadostreamform`
if [ "$res" == "" ]; then
	pip3 install tornadostreamform
fi

# 2017-11-22 => jack-smf-utils, playback and record MID files
if [ ! -d "$ZYNTHIAN_SW_DIR/jack-smf-utils-1.0" ]; then
	bash $ZYNTHIAN_RECIPE_DIR/install_jack-smf-utils.sh
fi

# 2017-11-29 => jsonpickle, required by zynthian-webconf
res=`pip3 show jsonpickle`
if [ "$res" == "" ]; then
	pip3 install jsonpickle
fi

# 2018-01-23 => replace jackclient-python by a customized version
if [ ! -d "$ZYNTHIAN_SW_DIR/jackclient-python" ]; then
	yes | pip3 uninstall JACK-Client
	bash $ZYNTHIAN_RECIPE_DIR/install_jackclient-python.sh
fi

# 2018-03-11 => Install Pianoteq 6.0 Demo
if [ ! -d "$ZYNTHIAN_SW_DIR/pianoteq6" ]; then
	cd $ZYNTHIAN_SW_DIR
	wget http://blog.zynthian.org/download/pianoteq6.tar.bz2
	tar xfvj pianoteq6.tar.bz2
	rm pianoteq6.tar.bz2
	cd pianoteq6
	mv arm/* .
fi
