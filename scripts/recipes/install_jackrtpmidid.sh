# jackrtpmidi

cd $ZYNTHIAN_SW_DIR

SW_DIR="jackrtpmidid"
if [ -d "$SW_DIR" ]; then
	rm -rf "$SW_DIR"
fi

git clone https://github.com/imodularsynth/jackrtpmidid
mv $SW_DIR/jackrtpmidid /usr/local/bin
chmod a+x /usr/local/bin/jackrtpmidid

rm -rf "$SW_DIR"
