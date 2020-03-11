# jackrtpmidi

cd $ZYNTHIAN_SW_DIR

SW_DIR="jackrtpmidid"
if [ -d "$SW_DIR" ]; then
	rm -rf "$SW_DIR"
fi

git clone https://github.com/imodularsynth/jackrtpmidid $SW_DIR
cd $SW_DIR
make all
cp -a ./dist/Release/GNU-Linux/jackrtpmidid /usr/local/bin
cd ..

rm -rf "$SW_DIR"
