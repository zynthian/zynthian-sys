

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
fi


