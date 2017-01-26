# drmr.lv2
cd $ZYNTHIAN_SW_DIR
sudo apt-get install -y liblo0-dev libmxml-dev
git clone git://git.code.sf.net/p/zynaddsubfx/code && mv code zynaddsubfx
cd zynaddsubfx
mkdir build
cd build
OLD_DATE=`date +%Y%m%d%H%M.%S`
cmake ..
for i in `find . -name "*.cmake"`
do
	sed -i -- 's/\${CMAKE_INSTALL_PREFIX}\/lib\/lv2/\/home\/pi\/zynthian\/zynthian-plugins\/mod-lv2/' $i
	touch -c $i -t$OLD_DATE
done
sed -i -- 's/-lX11 -lGL//' ./src/Plugin/ZynAddSubFX/CMakeFiles/ZynAddSubFX_lv2.dir/link.txt
sed -i -- 's/-lX11 -lGL//' ./src/Plugin/ZynAddSubFX/CMakeFiles/ZynAddSubFX_vst.dir/link.txt
make
sudo make install
sudo rm -rf /usr/local/lib/vst
make clean
cd ../..
