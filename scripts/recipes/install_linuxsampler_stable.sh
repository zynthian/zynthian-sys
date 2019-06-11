#!/bin/bash

# linuxsampler
set -ex
cd $ZYNTHIAN_SW_DIR

# Download, Build & Install needed libraries: libgig & libscp
rm -rf libgig-4.1.0
wget http://download.linuxsampler.org/packages/libgig-4.1.0.tar.bz2
tar xfvj libgig-4.1.0.tar.bz2
rm -f libgig-4.1.0.tar.bz2
cd libgig-4.1.0
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoconf 
./configure
make -j 1
make install
make clean
make distclean
cd ..

rm -rf liblscp-0.5.8
wget http://download.linuxsampler.org/packages/liblscp-0.5.8.tar.gz
tar xfvz liblscp-0.5.8.tar.gz
rm -f liblscp-0.5.8.tar.gz
cd liblscp-0.5.8
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoconf 
./configure
make -j 1
make install
make clean
make distclean
cd ..

# Download, Build &  Install LinuxSampler
rm -rf linuxsampler-2.1.0
wget http://download.linuxsampler.org/packages/linuxsampler-2.1.0.tar.bz2
tar xfvj linuxsampler-2.1.0.tar.bz2
rm -f linuxsampler-2.1.0.tar.bz2
cd linuxsampler-2.1.0
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoconf
#Configure with optimizations from Schpion
./configure --enable-max-voices=21 --enable-max-streams=64 --enable-stream-min-refill=4096 --enable-refill-streams=2 --enable-stream-max-refill=131072 --enable-stream-size=262144 --disable-asm --enable-subfragment-size=64 --enable-eg-min-release-time=0.001 --enable-eg-bottom=0.0025 --enable-max-pitch=2 --enable-preload-samples=65536
cd src/scriptvm
yacc -o parser parser.y
cd ../..
# Apply patch from Steveb
git clone https://github.com/steveb/rpi_linuxsampler_patch.git
patch -p1 < rpi_linuxsampler_patch/linuxsampler-arm.patch
# Build LinuxSampler
make -j 1
make install
ln -s /usr/local/lib/lv2/linuxsampler.lv2 ${ZYNTHIAN_PLUGINS_DIR}/lv2
make clean
cd ..
