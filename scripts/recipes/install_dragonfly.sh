#!/bin/bash
set -e

#REQUIRE: libx11-dev libgl1-mesa-dev libjack-jackd2-dev

DRAGONFLY_RELEASE=2.0.0-rc1

cd $ZYNTHIAN_PLUGINS_SRC_DIR

rm -rf dragonfly-reverb
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
git apply - <<EOF
diff --git a/Makefile.base.mk b/Makefile.base.mk
index 90c22da..21628e2 100644
--- a/Makefile.base.mk
+++ b/Makefile.base.mk
@@ -90,7 +90,7 @@ endif
 # Set build and link flags
 
 BASE_FLAGS = -Wall -Wextra -pipe -MD -MP
-BASE_OPTS  = -O3 -ffast-math -mtune=generic -msse -msse2 -fdata-sections -ffunction-sections
+BASE_OPTS  = -O3 -ffast-math -fdata-sections -ffunction-sections
 
 ifeq (\$(MACOS),true)
 # MacOS linker flags
EOF

cd ..
make

cp -rp bin/*.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

cd ../..
