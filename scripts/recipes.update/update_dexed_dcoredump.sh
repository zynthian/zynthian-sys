
cd $ZYNTHIAN_PLUGINS_SRC_DIR/dexed
git pull origin native-lv2 | grep -q -v 'Already up-to-date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	cd src
	make
	sudo make install
	cd ..
fi
cd ..
