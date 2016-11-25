# qmidiarp
cd $ZYNTHIAN_SW_DIR
git clone git://git.code.sf.net/p/qmidiarp/code qmidiarp-code
cd qmidiarp-code
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoconf 
./configure --enable-lv2plugins
make
sudo make install
make clean
cd ..
