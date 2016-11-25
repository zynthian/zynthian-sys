# stepseq.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/x42/stepseq.lv2.git
cd stepseq.lv2
sed -i -- 's/-msse -msse2 -mfpmath=sse/-march=armv6/' Makefile
sed -i -- 's/LV2DIR ?= \$(PREFIX)\/lib\/lv2/LV2DIR ?= \/zynthian\/zynthian-plugins\/lv2/' Makefile
sed -i -- 's/BUILDOPENGL?=yes/BUILDOPENGL?=no/' Makefile
sed -i -- 's/BUILDJACKAPP?=yes/BUILDJACKAPP?=no\nMOD?=yes/' Makefile
make -j 4
sudo make install
make clean
sed -i -- 's/N_NOTES ?= 8/N_NOTES ?= 16/' Makefile
sed -i -- 's/N_STEPS ?= 8/N_STEPS ?= 16/' Makefile
make -j 4
sudo make install
make clean
sed -i -- 's/N_NOTES ?= 16/N_NOTES ?= 8/' Makefile
sed -i -- 's/N_STEPS ?= 16/N_STEPS ?= 4/' Makefile
make -j 4
sudo make install
make clean
sed -i -- 's/N_NOTES ?= 8/N_NOTES ?= 4/' Makefile
make -j 4
sudo make install
make clean
#sed -i -- 's/N_STEPS ?= 8/N_STEPD ?= 16/' Makefile
#sed -i -- 's/N_NOTES ?= 8/N_NOTES ?= 4/' Makefile
#make
#sudo make install
#make clean
cd ..
