
# 2019-11-18: Install preset2lv2
if [ ! -d $ZYNTHIAN_SW_DIR/preset2lv2 ]; then
	$ZYNTHIAN_RECIPE_DIR/install_preset2lv2.sh
else
	echo "... preset2lv2 already installed!"
fi
