#!/bin/bash
set -e

#REQUIRE: libx11-dev libgl1-mesa-dev libjack-jackd2-dev

DRAGONFLY_RELEASE=3.0.0

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "dragonfly-reverb" ]; then
	rm -rf "dragonfly-reverb"
fi

git clone --recurse-submodules https://github.com/michaelwillis/dragonfly-reverb.git
cd dragonfly-reverb
git checkout $DRAGONFLY_RELEASE

git apply - <<EOF
diff --git a/common/Makefile.mk b/common/Makefile.mk
index 8f5dec1..93d1484 100644
--- a/common/Makefile.mk
+++ b/common/Makefile.mk
@@ -23,7 +23,7 @@ endif
 # Set build and link flags
 
 BASE_FLAGS = -Wall -Wextra -pipe -MD -MP
-BASE_OPTS  = -O2 -mtune=generic -msse -msse2 -fdata-sections -ffunction-sections
+BASE_OPTS  = -O2 -fdata-sections -ffunction-sections
 
 ifeq (\$(MACOS),true)
 # MacOS linker flags
EOF

cd dpf
make -j 4
cd ..
make -j 4
cp -rp bin/*.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

cd ..
rm -rf "dragonfly-reverb"

