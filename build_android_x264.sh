#!/bin/bash
NDK=/Users/dyno/Library/Android/sdk/ndk-bundle
OUTPUT_DIR=`pwd`/x264
SOURCE=../x264-0.148.r2705
TEMP_DIR="tmp/264"

ARCHS="armeabi-v7a arm64-v8a x86_64 x86"
#ARCHS="armeabi-v7a arm64-v8a x86_64 x86"
CONFIGURE_FLAGS="--enable-static --enable-pic --disable-cli "
PLATFORM=""
TOOLCHAIN=""
CROSS_PREFIX=""
HOST=""
CWD=`pwd`

for ARCH in $ARCHS
do
	echo "building $ARCH..."
	mkdir -p "$TEMP_DIR/$ARCH"
	cd "$TEMP_DIR/$ARCH"
	PREFIX=$OUTPUT_DIR/$ARCH
	case $ARCH in
	armeabi-v7a)
		PLATFORM=$NDK/platforms/android-19/arch-arm/
		TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
		CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
		HOST="arm-linux"
	;;
	arm64-v8a)
		PLATFORM=$NDK/platforms/android-21/arch-arm64/
		TOOLCHAIN=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64
		CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
		HOST="aarch64-linux"
	;;
	x86_64)
		PLATFORM=$NDK/platforms/android-21/arch-x86_64/
		TOOLCHAIN=$NDK/toolchains/x86_64-4.9/prebuilt/darwin-x86_64
		CROSS_PREFIX=$TOOLCHAIN/bin/x86_64-linux-android-
		HOST="x86_64-linux"
	;;
	x86)
		PLATFORM=$NDK/platforms/android-19/arch-x86/
		TOOLCHAIN=$NDK/toolchains/x86-4.9/prebuilt/darwin-x86_64
		CROSS_PREFIX=$TOOLCHAIN/bin/i686-linux-android-
		HOST="i686-linux"
	;;
	esac

	echo "platform:$PLATFORM"
	echo "toolchains:$TOOLCHAIN"
	echo "cross-prefix:$CROSS_PREFIX"
	echo "prefix:$PREFIX"
	echo "host:$HOST"

	TMPDIR=${TMPDIR/%\/} $CWD/$SOURCE/configure \
	  ${CONFIGURE_FLAGS} \
	  --prefix=$PREFIX \
	  --host=$HOST \
	  --cross-prefix=$CROSS_PREFIX \
	  --sysroot=$PLATFORM || exit 1
	make -j4 install
	cd $CWD
done


echo Android builds finished
