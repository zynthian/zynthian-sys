#Install_mod-lv2-data.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/moddevices/mod-lv2-data.git
cd mod-lv2-data

#For all plugins installed in zynthian dir ...
for d in `ls -d $ZYNTHIAN_PLUGINS_DIR/lv2/*.lv2`; do
	B=`basename "${d}"`
	# If plugin doesn't have a modgui dir ...
	ls -d "${d}"/modgui >/dev/null 2>&1
	if [ $? != 0 ]; then
		ls -d ./plugins-fixed/"${B}"/modgui >/dev/null 2>&1
		if [ $? = 0 ]; then
				echo "Found modgui for ${B} ..."
				#rsync -avP ./plugins-fixed/"${B}"/ $ZYNTHIAN_PLUGINS_DIR/lv2/"${B}"
				cp -a ./plugins-fixed/"${B}"/modgui $ZYNTHIAN_PLUGINS_DIR/lv2/"${B}"
				cp -a ./plugins-fixed/"${B}"/modgui.ttl $ZYNTHIAN_PLUGINS_DIR/lv2/"${B}"
				continue
		fi
		ls -d ./plugins/"${B}"/modgui >/dev/null 2>&1
		if [ $? = 0 ]; then
				echo "Found modgui for ${B} ..."
				#rsync -avP ./plugins/"${B}"/ $ZYNTHIAN_PLUGINS_DIR/lv2/"${B}"
				cp -a ./plugins/"${B}"/modgui $ZYNTHIAN_PLUGINS_DIR/lv2/"${B}"
				cp -a ./plugins/"${B}"/modgui.ttl $ZYNTHIAN_PLUGINS_DIR/lv2/"${B}"
				continue
		fi
		echo "No modgui found for ${B}"
	fi
done

#Delete mod-lv2-data
cd $ZYNTHIAN_PLUGINS_SRC_DIR
rm -rf mod-lv2-data
