# openav-artyfx.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/openAVproductions/openAV-ArtyFX.git
cd openAV-ArtyFX
sed -i -- 's/ lib\/lv2\// \/zynthian\/zynthian-plugins\/lv2\//' CMakeLists.txt
cmake -DHAVE_NTK=OFF
make -j 4
sudo make install
make clean
cd ..
