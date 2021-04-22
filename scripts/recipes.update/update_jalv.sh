
cd $ZYNTHIAN_SW_DIR/jalv

git checkout .
git pull | grep -q -v 'Already up.to.date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	./waf --no-qt4 configure
	./waf build
	./waf install
	./waf --no-qt5 configure
	./waf build
	./waf install
fi
