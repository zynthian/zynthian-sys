#!/bin/bash

package_name=drumgizmo-0.9.20

apt install -y libsmf-dev libmp3lame-dev libmpg123-dev libopus-dev

cd $ZYNTHIAN_SW_DIR
if [ -d $package_name ]; then 
	rm -rf $package_name
fi

# Download and extract source code
wget http://www.drumgizmo.org/releases/$package_name/$package_name.tar.gz
tar xfvz $package_name.tar.gz
rm -rf $package_name.tar.gz

# Build from source code
cd $package_name
./configure --prefix=$PWD/install --enable-lv2 --enable-custom-channel-count=2
#--enable-custom-channel-count[=count]]
#--enable-gui
make -j 3
make install


#rm -rf $package_name


