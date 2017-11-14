
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

