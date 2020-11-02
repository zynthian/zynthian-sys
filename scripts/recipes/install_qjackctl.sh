#!/bin/bash

res=`dpkg -s qjackctl 2>&1 | grep "Status:"`
if [ "$res" == "Status: install ok installed" ]; then
	apt-get -y remove qjackctl
fi

cd $ZYNTHIAN_SW_DIR

if [ -d "qjackctl" ]; then
	rm -rf qjackctl
fi

git clone https://github.com/rncbc/qjackctl.git
cd qjackctl
git checkout tags/qjackctl_0_6_3
./autogen.sh
./configure
make -j 3
cd src
make install
cd ../..

rm -rf qjackctl
