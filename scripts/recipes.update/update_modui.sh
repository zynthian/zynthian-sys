
cd $ZYNTHIAN_SW_DIR/mod-host
git pull | grep -q -v 'Already up-to-date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	make -j 4
	make install
	make clean
	cd ..
fi

cd $ZYNTHIAN_SW_DIR/mod-ui
git pull | grep -q -v 'Already up-to-date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	pip3 install -r requirements.txt
	cd utils
	make -j 4
	cd ..
fi

if [ ! -d "$ZYNTHIAN_SW_DIR/mod-ui/data" ]; then
	mkdir "$ZYNTHIAN_SW_DIR/mod-ui/data"
fi

if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/presets/lv2" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/lv2"
	mv /root/.lv2/* "$ZYNTHIAN_MY_DATA_DIR/presets/lv2"
	rm -rf /root/.lv2
	ln -s "$ZYNTHIAN_MY_DATA_DIR/presets/lv2" /root/.lv2
	sed -i -e "s/\/lv2\"/\/lv2\:\$ZYNTHIAN_MY_DATA_DIR\/presets\/lv2\"/g" $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh
	# Reboot
	touch $REBOOT_FLAGFILE
fi
