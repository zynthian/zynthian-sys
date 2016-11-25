# libne10
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/projectNe10/Ne10
cd Ne10
mkdir build && cd build
export CMAKE_C_FLAGS="-std=c99"
cmake CMAKE_C_FLAGS="-std=c11" -DGNULINUX_PLATFORM=ON -DNE10_LINUX_TARGET_ARCH="armv7" -DNE10_BUILD_SHARED=ON ..
make
sudo make install
make clean
cd ../..
