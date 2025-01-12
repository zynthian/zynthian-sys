


cd $ZYNTHIAN_SW_DIR

if [ -d "jacknetumpd" ]; then
	rm -rf jacknetumpd
fi

git clone https://github.com/bbouchez/jacknetumpd
cd jacknetumpd
git clone https://github.com/bbouchez/BEBSDK
git clone https://github.com/bbouchez/NetUMP

cd jacknetumpd

sed -i "s#\.\.\/\.\.\/\.\.\/\.\.\/\.\.\/SDK\/beb\/common_src#../BEBSDK#g" nbproject/Makefile-Release.mk
sed -i "s#\.\.\/\.\.\/\.\.\/\.\.\/\.\.\/SDK\/beb\/common_src#../BEBSDK#g" nbproject/Makefile-Debug.mk

sed -i "s#\.\.\/\.\.\/NetUMP#../NetUMP#g" nbproject/Makefile-Release.mk
sed -i "s#\.\.\/\.\.\/NetUMP#../NetUMP#g" nbproject/Makefile-Debug.mk

sed -i "s#DEFAULTCONF\=Debug#DEFAULTCONF=Release#g" nbproject/Makefile-impl.mk

make -j 3
cp -a ./dist/Release/GNU-Linux/jacknetumpd /usr/local/bin

cd ../..
rm -rf jacknetumpd

