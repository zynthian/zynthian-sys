# midish

cd $ZYNTHIAN_SW_DIR
git clone https://github.com/ratchov/midish.git

cd midish
./configure
make -j 3
make install
make clean
cd ..
