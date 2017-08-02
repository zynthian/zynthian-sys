# linuxsampler
set -ex
cd $ZYNTHIAN_SW_DIR
sudo apt-get install -y subversion libtool flex bison
svn co https://svn.linuxsampler.org/svn/libgig/trunk libgig
cd libgig
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoconf 
./configure
make
sudo make install
make clean
cd ..
svn co https://svn.linuxsampler.org/svn/liblscp/trunk liblscp
cd liblscp
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoconf 
./configure
make
sudo make install
make clean
cd ..
svn co https://svn.linuxsampler.org/svn/linuxsampler/trunk linuxsampler
cd linuxsampler
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoconf
./configure
cd src/scriptvm
yacc -o parser parser.y
cd ../..
git clone https://github.com/steveb/rpi_linuxsampler_patch.git
patch -p1 <rpi_linuxsampler_patch/linuxsampler-arm.patch 
make
sudo make install
sudo mv /usr/local/lib/lv2/linuxsampler.lv2 ${ZYNTHIAN_PLUGINS_DIR}/mod-lv2
make clean
cd ..
