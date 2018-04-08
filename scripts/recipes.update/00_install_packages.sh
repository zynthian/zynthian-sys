

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
	wget http://blog.zynthian.org/download/pianoteq6_demo.tar.xz
	tar xfvJ pianoteq6_demo.tar.xz
	mv pianoteq6_demo pianoteq6
	rm pianoteq6_demo.tar.xz
	ln -s "$ZYNTHIAN_SW_DIR/pianoteq6/Pianoteq 6 STAGE.lv2" "$ZYNTHIAN_PLUGINS_DIR/lv2"
fi

# 2018-03-14 => Install Helm Synthesizer & Upgrade System
if [ ! -d "$ZYNTHIAN_SW_DIR/plugins/helm" ]; then
	apt-get -y update
	apt-get -y upgrade
	apt-get -y --no-install-recommends install libxcursor-dev libxinerama-dev libcurl4-openssl-dev mesa-common-dev libgl1-mesa-dev libfreetype6-dev
	bash $ZYNTHIAN_RECIPE_DIR/install_helm.sh
fi

# 2018-03-14 => Install Infamous Plugins
if [ ! -d "$ZYNTHIAN_SW_DIR/plugins/infamousPlugins" ]; then
	bash $ZYNTHIAN_RECIPE_DIR/install_infamous.sh
fi

# 2018-03-14 => Install Invada Plugins
if [ ! -L "$ZYNTHIAN_PLUGINS_DIR/lv2/invada.lv2" ]; then
	apt-get -y --no-install-recommends install invada-studio-plugins-lv2
	ln -s /usr/lib/lv2/invada.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
fi

# 2018-03-14 => Install padthv1
if [ ! -d "$ZYNTHIAN_SW_DIR/plugins/padthv1" ]; then
	apt-get -y update
	apt-get -y --no-install-recommends install qt5-qmake qt5-default
	bash $ZYNTHIAN_RECIPE_DIR/install_padthv1.sh
fi

# 2018-04-08 => Install obxd bank
if [ ! -d "$ZYNTHIAN_SW_DIR/plugins/obxd_bank" ]; then
	bash $ZYNTHIAN_RECIPE_DIR/install_obxd_bank.sh
fi

