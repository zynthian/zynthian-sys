# Mod-Host
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/moddevices/mod-host.git
cd mod-host

if [[ $MOD_HOST_GITSHA ]]; then
	git branch -f zynthian $MOD_HOST_GITSHA
	git checkout zynthian
fi

#patch -p1 <"${HOME}/zynthian/zynthian-recipe/mod-host.patch.txt"
make -j 4
sudo make install
make clean
