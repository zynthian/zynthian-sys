
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
