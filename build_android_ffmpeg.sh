#!/usr/bin/env bash
#Change NDK to your Android NDK location
CWD=`pwd`
NDK=/Users/dyno/Library/Android/sdk/ndk-bundle
SOURCE=../ffmpeg-3.1.1
OUTPUT_DIR=$CWD/android/ffmpeg
X264_DIR=$CWD/android/x264
ACC_DIR=
TEMP_DIR="tmp/android/ffmpeg"
ARCHS="armeabi-v7a x86_64 x86"
#armeabi-v7a arm64-v8a x86_64 x86

MODULES="\
--enable-gpl \
--enable-libx264"
#--enable-libfdk-aac



GENERAL="\
--logfile=conflog.txt \
--target-os=linux \
--enable-small \
--enable-cross-compile \
--extra-libs="-lgcc" \
--enable-shared \
--disable-static \
--disable-doc \
--enable-zlib \
--disable-programs \
--disable-debug"

CFLAGS="-O3 -Wall -pipe \
    -std=c99 \
    -ffast-math \
    -fstrict-aliasing -Werror=strict-aliasing \
    -Wno-psabi -Wa,--noexecstack \
    -DANDROID -DNDEBUG"
LFLAGS=

for ARCH in $ARCHS; do
	PLATFORM=
	TOOLCHAIN=
	ARCH_FLAGS=
	EXTRA_CFLAGS=
	EXTRA_LDFLAGS=
	echo "building $ARCH..."
	mkdir -p "$TEMP_DIR/$ARCH"
	cd "$TEMP_DIR/$ARCH"
	case $ARCH in
	armeabi-v7a)
		PLATFORM=$NDK/platforms/android-19/arch-arm/
		TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin/arm-linux-androideabi

		ARCH_FLAGS="$ARCH_FLAGS --arch=arm --cpu=cortex-a8"
		ARCH_FLAGS="$ARCH_FLAGS --enable-neon"
		ARCH_FLAGS="$ARCH_FLAGS --enable-thumb"
		
		EXTRA_CFLAGS="$EXTRA_CFLAGS  -fPIC -ffunction-sections -funwind-tables -fstack-protector -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300"
		EXTRA_LDFLAGS="$EXTRA_LDFLAGS"
	;;
	arm64-v8a)
		PLATFORM=$NDK/platforms/android-21/arch-arm64/
		TOOLCHAIN=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64/bin/aarch64-linux-android

		ARCH_FLAGS="$ARCH_FLAGS --arch=aarch64 --enable-yasm"

		EXTRA_CFLAGS="$EXTRA_CFLAGS"
		EXTRA_LDFLAGS="$EXTRA_LDFLAGS"
	;;
	x86_64)
		PLATFORM=$NDK/platforms/android-21/arch-x86_64/
		TOOLCHAIN=$NDK/toolchains/x86_64-4.9/prebuilt/darwin-x86_64/bin/x86_64-linux-android
		
		ARCH_FLAGS="$ARCH_FLAGS --arch=x86_64 --enable-yasm"

		EXTRA_CFLAGS="$EXTRA_CFLAGS -march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel"
		EXTRA_LDFLAGS="$EXTRA_LDFLAGS"
	;;
	x86)
		PLATFORM="$NDK/platforms/android-19/arch-x86/"
		TOOLCHAIN="$NDK/toolchains/x86-4.9/prebuilt/darwin-x86_64/bin/i686-linux-android"
		
		ARCH_FLAGS="$ARCH_FLAGS --arch=x86 --cpu=i686 --enable-yasm"

		EXTRA_CFLAGS="$EXTRA_CFLAGS -Dipv6mr_interface=ipv6mr_ifindex -fasm -fno-short-enums -fno-strict-aliasing -fomit-frame-pointer -march=i686 -msse3 -ffast-math -mfpmath=sse -mtune=intel -m32"
		EXTRA_LDFLAGS="$EXTRA_LDFLAGS"
	;;
	esac

	ARCH_FLAGS="$ARCH_FLAGS --cc=$TOOLCHAIN-gcc"
	ARCH_FLAGS="$ARCH_FLAGS --cross-prefix=$TOOLCHAIN-"
	ARCH_FLAGS="$ARCH_FLAGS --nm=$TOOLCHAIN-nm"
	ARCH_FLAGS="$ARCH_FLAGS --prefix=$OUTPUT_DIR/$ARCH"
	ARCH_FLAGS="$ARCH_FLAGS --sysroot=$PLATFORM"

	if [ "$X264_DIR" ] ; then
		EXTRA_CFLAGS="$EXTRA_CFLAGS -I$X264_DIR/$ARCH/include"
		EXTRA_LDFLAGS="$EXTRA_LDFLAGS -L$X264_DIR/$ARCH/lib"
	fi
	if [ "$ACC_DIR" ] ; then
		EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ACC_DIR/$ARCH/include"
		EXTRA_LDFLAGS="$EXTRA_LDFLAGS -L$ACC_DIR/$ARCH/lib"
	fi

	LFLAGS="-lx264 -Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	echo "platform:$PLATFORM"
	echo "toolchain:$TOOLCHAIN"
	echo "arch_flags:$ARCH_FLAGS"
	echo "cflags:$EXTRA_CFLAGS"
	echo "lflags:$EXTRA_LDFLAGS"

	TMPDIR=${TMPDIR/%\/} $CWD/$SOURCE/configure \
	${GENERAL} \
	${MODULES} \
	${ARCH_FLAGS} \
	--extra-cflags="$CFLAGS $EXTRA_CFLAGS" \
	--extra-ldflags="$LFLAGS $EXTRA_LDFLAGS" || exit 1

	make clean
	make
	make -j4 install
	cd $CWD
done

echo android build finished