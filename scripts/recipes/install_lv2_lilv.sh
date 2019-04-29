#!/bin/bash

# LV2, lilv and Python bindings
cd $ZYNTHIAN_SW_DIR

git clone --recursive https://github.com/drobilla/lv2.git
cd lv2
./waf configure
./waf build
./waf install
./waf clean

if [ ! -f "/usr/local/include/lv2.h" ]; then
	ln -s /usr/local/include/lv2/lv2.h /usr/local/include/lv2.h
fi

if [ ! -f "/usr/local/lib/pkgconfig/lv2core.pc" ]; then
	ln -s /usr/local/lib/pkgconfig/lv2.pc /usr/local/lib/pkgconfig/lv2core.pc
fi
cd ..

git clone --recursive https://github.com/drobilla/serd.git
#git clone --recursive http://git.drobilla.net/serd.git/
cd serd
./waf configure
./waf build
./waf install
./waf clean
cd ..

git clone --recursive https://github.com/drobilla/sord.git
#git clone --recursive http://git.drobilla.net/sord.git/
cd sord
./waf configure
./waf build
./waf install
./waf clean
cd ..

git clone --recursive https://github.com/drobilla/sratom.git
#git clone http://git.drobilla.net/sratom.git sratom
cd sratom
./waf configure
./waf build
./waf install
./waf clean
cd ..

git clone --recursive https://github.com/drobilla/lilv.git
#git clone --recursive http://git.drobilla.net/lilv.git lilv
cd lilv
#./waf configure --bindings --python=/usr/bin/python2
#./waf build
#sudo ./waf install
#./waf clean
./waf configure --bindings --python=/usr/bin/python3
./waf build
./waf install
if [ -d "/usr/lib/python3.4" ]; then
	cp ./bindings/python/lilv.py /usr/lib/python3.4
elif [ -d "/usr/lib/python3.5" ]; then
	cp ./bindings/python/lilv.py /usr/lib/python3.5
fi
./waf clean
cd ..

git clone https://github.com/brunogola/lilv_python_examples
cd lilv_python_examples
2to3 -w *.py
export PYTHONPATH="/usr/local/lib/python3/dist-packages"
python3 lv2ls.py

