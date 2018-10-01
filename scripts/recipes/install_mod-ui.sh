#!/bin/bash

# mod-ui
cd $ZYNTHIAN_SW_DIR
git clone --recursive https://github.com/zynthian/mod-ui.git
cd mod-ui
git checkout zynthian-single-commit

if [[ -n $MOD_UI_GITSHA ]]; then
	git branch -f zynthian $MOD_UI_GITSHA
	git checkout zynthian
fi

sudo pip3 install -r requirements.txt
cd utils
make

if [ ! -d "$ZYNTHIAN_SW_DIR/mod-ui/data" ]; then
	mkdir "$ZYNTHIAN_SW_DIR/mod-ui/data"
fi
