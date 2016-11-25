# EQ10q
cd $ZYNTHIAN_PLUGINS_SRC_DIR
svn checkout svn://svn.code.sf.net/p/eq10q/code/trunk eq10q-code
cd eq10q-code
sed -i -- 's/-msse -mfpmath=sse/-march=armv6/' CMakeLists.txt
sed -i -- 's/CMAKE_INSTALL_PREFIX  "\/usr\/local\/lib\/lv2"/CMAKE_INSTALL_PREFIX  "\/zynthian\/zynthian-plugins\/mod-lv2"/' CMakeLists.txt
sed -i -- 's/^add_subdirectory(gui)/#add_subdirectory(gui)/' CMakeLists.txt
#sudo mv /usr/lib/arm-linux-gnueabihf/pkgconfig/glibmm-2.4.pc /usr/lib/arm-linux-gnueabihf/pkgconfig/glibmm-2.4.pc.tmp
cmake .
#sudo mv /usr/lib/arm-linux-gnueabihf/pkgconfig/glibmm-2.4.pc.tmp /usr/lib/arm-linux-gnueabihf/pkgconfig/glibmm-2.4.pc
make -j 4
sudo make install
make clean
