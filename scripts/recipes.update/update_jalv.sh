
cd $ZYNTHIAN_SW_DIR/jalv

# Change to Master branch if needed
branch_name="$(git symbolic-ref HEAD 2>/dev/null)"
is_zynthian_branch="$(echo $branch_name | grep zynthian)"
if [[ "$is_zynthian_branch" != "" ]]; then
	cd ..
	rm -rf jalv
	git clone --recursive https://github.com/zynthian/jalv.git
	cd jalv
	./waf configure
	./waf build
	./waf install
	exit
fi

git pull | grep -q -v 'Already up.to.date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	./waf configure
	./waf build
	./waf install
fi
