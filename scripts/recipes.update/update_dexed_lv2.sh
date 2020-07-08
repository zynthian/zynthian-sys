
cd $ZYNTHIAN_PLUGINS_SRC_DIR/dexed.lv2
git pull | grep -q -v 'Already up.to.date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	cd src
	make -j 3
	make install
	cd ..
fi
cd ..
