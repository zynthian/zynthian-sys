
if [ -d "$ZYNTHIAN_SW_DIR/jalv" ]; then
	cd $ZYNTHIAN_SW_DIR/jalv

	git checkout .
	git pull | grep -q -v 'Already up.to.date.' && changed=1
	if [[ "$changed" -eq 1 ]]; then
		if [ ! -d  "./build" ]; then
			meson setup build
		fi
		cd build
		meson compile
		meson install
		ldconfig
	fi
fi