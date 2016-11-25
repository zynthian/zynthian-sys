# dxsyx
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/rogerallen/dxsyx.git
cd dxsyx
make
sudo cp bin/dxsyx /usr/local/bin
sudo chmod 755 /usr/local/bin/dxsyx
make clean
cd ..
