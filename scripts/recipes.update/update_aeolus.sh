cd $ZYNTHIAN_SW_DIR

if [ ! -d "aeolus" ]; then
git clone https://github.com/riban-bw/aeolus.git
fi

cd aeolus
cd aeolus/source
git checkout zynthian
git pull | grep -q -v 'Already up.to.date.' && changed=1
if [ "$changed" -eq 1 ]; then
	make clean
	make -j 3
	make install
fi
cd -
