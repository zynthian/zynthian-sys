#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "reMID.lv2" ]; then
	rm -rf "reMID.lv2"
fi

git clone https://github.com/ssj71/reMID.lv2.git
cd reMID.lv2
mkdir build
cd build
cmake ..
make -j 2
make install
make clean
cd ..
rm -rf "reMID.lv2"

for f in /usr/local/lib/lv2/remid.lv2/*.conf; do
	if [ "$f" != "/usr/local/lib/lv2/remid.lv2/instruments.conf" ]; then
		sed -i -- 's/1=1/1=1\n2=1\n3=1\n4=1\n5=1\n6=1\n7=1\n8=1\n9=1\n10=1\n11=1\n12=1\n13=1\n14=1\n15=1\n16=1/' $f
	fi
done
