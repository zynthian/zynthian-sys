#!/bin/bash

# SW directory
cd $ZYNTHIAN_SW_DIR

if [ -d  TkinterWeb ]; then
	rm -rf  TkinterWeb
fi

git clone https://github.com/jofemodo/TkinterWeb
cd TkinterWeb
python3 ./setup.py install
cd ..

rm -rf TkinterWeb

: '
# Build Tkhtml
apt install tk-dev
git clone https://github.com/Andereoo/TkinterWeb-Tkhtm
cd TkinterWeb-Tkhtm
export TCL_BASE=/usr
export PATH=$TCL_BASE/bin:$PATH
tclsh src/cssprop.tcl && tclsh src/tokenlist.txt & tclsh src/mkdefaultstyle.tcl > htmldefaultstyle.c
mv *.c src && mv *.h src
mkdir build
cd build
../configure CC="gcc -static-libgcc" --with-tcl=$TCL_BASE/lib/tcl8.6 --with-tk=$TCL_BASE/lib/tk8.6 --with-tclinclude=$TCL_BASE/include/tcl8.6 --with-tkinclude=$TCL_BASE/include/tcl8.6
make -j 3
make install
'
