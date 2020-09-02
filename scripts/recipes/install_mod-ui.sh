#!/bin/bash

# mod-ui
cd $ZYNTHIAN_SW_DIR
#git clone --recursive https://github.com/zynthian/mod-ui.git
git clone --recursive --single-branch --branch zyn-mod-merge https://github.com/steveb/mod-ui.git
cd mod-ui

if [[ -n $MOD_UI_GITSHA ]]; then
	git branch -f zynthian $MOD_UI_GITSHA
	git checkout zynthian
fi

#pip3 install -r requirements.txt
#pip3 install pyserial==2.7 pystache==0.5.4 aggdraw==1.3.7
pip3 install pyserial==3.0 pystache==0.5.4 aggdraw==1.3.11
pip3 install git+git://github.com/dlitz/pycrypto@master#egg=pycrypto
#Pillow==6.2.2
#tornado==4.3

cd utils
make

if [ ! -d "$ZYNTHIAN_SW_DIR/mod-ui/data" ]; then
	mkdir "$ZYNTHIAN_SW_DIR/mod-ui/data"
fi
