
cd $ZYNTHIAN_SW_DIR/mod-host

# Normal Updates => Temporary disabled
#git pull | grep -q -v 'Already up.to.date.' && changed=1
#if [[ "$changed" -eq 1 ]]; then

# WARNING Temporary workaround until we update Jackd version!
# Fix repo position so it doesn't need a recent Jack version (JackTickDouble)
# SHA => 0d1cb5484f5432cdf7fa297e0bfcc353d8a47e6b
shash="0d1cb54"
res=`git branch | grep "* (HEAD detached at $shash)"`
if [ "$res" != "* (HEAD detached at $shash)" ]; then
	git checkout --detach $shash

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
