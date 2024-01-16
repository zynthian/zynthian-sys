cd $ZYNTHIAN_SW_DIR

if [ ! -d "aeolus" ]
then
	git clone https://github.com/riban-bw/aeolus.git
	cd aeolus
	git checkout zynthian
	changed=1
else
	cd aeolus
	git checkout .
	git pull | grep -q -v 'Already up to date.' && changed=1
fi
if [ "$changed" == "1" ]
then
	cd source
	make clean
	make -j 3
	make install
fi
