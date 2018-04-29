# mod-ui
cd $ZYNTHIAN_SW_DIR
git clone --recursive https://github.com/zynthian/mod-ui.git
cd mod-ui

if [[ -n $MOD_UI_GITSHA ]]; then
	git branch -f zynthian $MOD_UI_GITSHA
	git checkout zynthian
fi

sed -i "/\b\(pycrypto\)\b/d" requirements.txt
sudo pip3 install -r requirements.txt
cd utils
make

if [ ! -d "$ZYNTHIAN_SW_DIR/mod-ui/data" ]; then
	mkdir "$ZYNTHIAN_SW_DIR/mod-ui/data"
fi
