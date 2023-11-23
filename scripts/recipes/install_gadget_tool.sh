

cd $ZYNTHIAN_SW_DIR

# Install some dependencies
apt install libconfig-dev

# Install libusbgx => Probably available as deb package in bookworm
git clone https://github.com/libusbgx/libusbgx
cd libusbgx
autoreconf -i
./configure
make
make -j 3 install


# Install gt tool
git clone https://github.com/kopasiak/gt
mkdir ./gt/source/build
cd ./gt/source/build
cmake ..
make
make isntall




