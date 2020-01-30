

# 2019-08-14: Build mod-caps LV2 plugins that wan't correctly built on Aruk RC-3
date_caps_lv2=`stat -c %y $ZYNTHIAN_PLUGINS_SRC_DIR/caps-lv2`
if [ "$date_caps_lv2" \< "2019-08-01" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_mod-caps.sh
fi

# 2019-11-18: Install preset2lv2
if [ ! -d $ZYNTHIAN_SW_DIR/preset2lv2 ]; then
	$ZYNTHIAN_RECIPE_DIR/install_preset2lv2.sh
fi

# 2019-11-28: Install amsynth
if [ ! -e $ZYNTHIAN_PLUGINS_DIR/lv2/amsynth.lv2 ]; then
	$ZYNTHIAN_RECIPE_DIR/install_amsynth.sh
	rm -f $ZYNTHIAN_CONFIG_DIR/jalv/all_plugins.json
fi

# 2019-11-29: Install ams-lv2 (Alsa Modular Synth)
if [ ! -e $ZYNTHIAN_PLUGINS_DIR/lv2/mod-ams.lv2 ]; then
	$ZYNTHIAN_RECIPE_DIR/install_ams-lv2.sh
	rm -f $ZYNTHIAN_CONFIG_DIR/jalv/all_plugins.json
fi

# 2019-11-30 => Vorbis tools (oggenc, etc.)
res=`dpkg -s vorbis-tools 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	apt-get -y update
	apt-get -y install vorbis-tools
fi

# 2020-01-20 => fbcat
res=`dpkg -s fbcat 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	apt-get -y update
	apt-get -y install fbcat
fi

# 2020-01-29: Install jackrtpmidid
if [ ! -f /usr/local/bin/jackrtpmidid ]; then
	$ZYNTHIAN_RECIPE_DIR/install_jackrtpmidid.sh
fi

# 2020-01-30: Install ykchorus
if [ ! -e $ZYNTHIAN_PLUGINS_DIR/lv2/ykchorus.lv2 ]; then
	$ZYNTHIAN_RECIPE_DIR/install_ykchorus.sh
fi
