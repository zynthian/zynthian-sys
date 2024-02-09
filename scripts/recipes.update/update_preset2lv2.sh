
if [ -d "$ZYNTHIAN_SW_DIR/preset2lv2" ]; then
	cd $ZYNTHIAN_SW_DIR/preset2lv2
	git pull | grep -q -v 'Already up.to.date.' && changed=1
	if [[ "$changed" -eq 1 ]]; then
		python3 ./setup.py install
	fi
	cd ..
fi