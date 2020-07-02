
# 2020-05-19 => mutagen, for audio/mid file metadata
res=`pip3 show mutagen`
if [ "$res" == "" ]; then
	#pip3 install mutagen
	$ZYNTHIAN_RECIPE_DIR/install_mutagen.sh
fi

# 2020-05-31 => Enabled new zynthian-config-on-boot service
systemctl enable zynthian-config-on-boot

# 2020-06-03: Install arpeggiator
if [ ! -e $ZYNTHIAN_PLUGINS_DIR/lv2/bg-arpeggiator.lv2 ]; then
	$ZYNTHIAN_RECIPE_DIR/install_arpeggiator.sh
fi

# 2020-06-22: Install stereo-mixer
if [ ! -e $ZYNTHIAN_PLUGINS_DIR/lv2/stereo-mixer.lv2 ]; then
	$ZYNTHIAN_RECIPE_DIR/install_stereo-mixer.sh
fi

