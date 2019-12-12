
cd $ZYNTHIAN_SW_DIR/jack-smf-utils
git pull | grep -q -v 'Already up.to.date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	make -j 3
	make install
	make clean
fi
cd ..
