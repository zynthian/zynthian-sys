

# 2017-11-21 => tornadostreamform, required by zynthian-webconf
res=`pip3 show tornadostreamform`
if [ "$res" == "" ]; then
	pip3 install tornadostreamform
fi

# 2017-11-22 => jack-smf-utils, playback and record MID files
if [ ! -d "$ZYNTHIAN_SW_DIR/jack-smf-utils" ]; then
	bash $ZYNTHIAN_RECIPE_DIR/install_jack-smf-utils.sh
fi

# 2017-11-29 => jsonpicklepip3, required by zynthian-webconf
res=`pip3 show jsonpicklepip3`
if [ "$res" == "" ]; then
	pip3 install jsonpickle
fi

