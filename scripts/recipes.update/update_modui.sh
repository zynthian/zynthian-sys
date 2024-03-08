

if [ -d "$ZYNTHIAN_SW_DIR/mod-host" ]; then
	cd "$ZYNTHIAN_SW_DIR/mod-host"
	git pull | grep -q -v 'Already up.to.date.' && changed=1
	if [[ "$changed" -eq 1 ]]; then
		make -j 4
		make install
		make clean
		cd ..
	fi
fi

if [ -d "$ZYNTHIAN_SW_DIR/mod-ui" ]; then
	cd "$ZYNTHIAN_SW_DIR/mod-ui"
	git pull | grep -q -v 'Already up.to.date.' && changed=1
	if [[ "$changed" -eq 1 ]]; then
		make -C utils
	fi
fi
