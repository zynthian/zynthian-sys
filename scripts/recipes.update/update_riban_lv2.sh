ORIG_PWD=$(pwd)
STABLE=2103
STABLE=3b22aa935b03fbd92a61b9dc52919cd3bc12e8a5

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