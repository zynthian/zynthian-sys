
cd $ZYNTHIAN_SW_DIR/jalv
git pull origin zynthian | grep -q -v 'Already up.to.date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	./waf configure
	./waf build
	./waf install
fi
cd ..
