
cd $ZYNTHIAN_SW_DIR/jalv

branch_name="$(git symbolic-ref HEAD 2>/dev/null)"
is_zynthian_branch="$(echo $branch_name | grep zynthian)"
if [[ "$is_zynthian_branch" -ne "" ]]; then
	# Change to Master branch
	rm -rf build
	rm -f .lock*
	git checkout .
	git checkout master
fi

git pull | grep -q -v 'Already up.to.date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	./waf configure
	./waf build
	./waf install
fi
cd ..
