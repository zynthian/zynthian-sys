ORIG_PWD=$(pwd)
STABLE=12bc8b3ee06312f5feb78cc894bf78107d3e9710

cd $ZYNTHIAN_PLUGINS_SRC_DIR/riban
CURRENT=$(git rev-parse HEAD)

if [ " $CURRENT " != " $STABLE " ]
then
	git checkout -fq "$STABLE"
	for dir in */
	do
		cd $dir
		sed -i "s#^PREFIX.*=.*#PREFIX := $ZYNTHIAN_PLUGINS_DIR#" Makefile
		sed -i "s#^DESTDIR.*=.*#DESTDIR := /lv2#" Makefile
		make
		make install
		cd -
	done
fi
cd $ORIG_PWD
