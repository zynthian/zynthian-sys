

# 2019-08-14: Build mod-caps LV2 plugins that wan't correctly built on Aruk RC-3
date_caps_lv2=`stat -c %y $ZYNTHIAN_PLUGINS_SRC_DIR/caps-lv2`
if [ "$date_caps_lv2" \< "2019-08-01" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_mod-caps.sh
else
	echo "... Caps-lv2 already fixed!"
fi



