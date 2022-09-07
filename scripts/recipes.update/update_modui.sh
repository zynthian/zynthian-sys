
cd $ZYNTHIAN_SW_DIR/mod-host

# WARNING This is a temporal workaround until we update Jackd version!
# Fix repo position to that not needs a recent Jack version (JackTickDouble)
git checkout --detach 0d1cb5484f5432cdf7fa297e0bfcc353d8a47e6b

git pull | grep -q -v 'Already up.to.date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	make -j 4
	make install
	make clean
	cd ..
fi

cd $ZYNTHIAN_SW_DIR/mod-ui
git remote remove origin
git remote add origin https://github.com/zynthian/mod-ui.git
git fetch origin zyn-mod-merge-next
git checkout zyn-mod-merge-next
git reset --hard origin/zyn-mod-merge-next

cd utils
make -j 4

if [ ! -d "$ZYNTHIAN_SW_DIR/mod-ui/data" ]; then
	mkdir "$ZYNTHIAN_SW_DIR/mod-ui/data"
fi

if [ ! -d "$ZYNTHIAN_SW_DIR/browsepy" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_mod-browsepy.sh
fi
