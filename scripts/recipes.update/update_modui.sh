
cd $ZYNTHIAN_SW_DIR/mod-ui
git pull | grep -q -v 'Already up-to-date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	cd utils
	make
	cd ..
fi
cd ..
