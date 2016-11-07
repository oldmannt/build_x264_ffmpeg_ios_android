# build_x264_ffmpeg_ios_android
my pc: macOS 10.12
x264: x264-0.148.r2705 www.videolan.org/developers/x264.html
ffmpeg: 3.1.1 https://github.com/FFmpeg/FFmpeg

###ios
builded in xcode7, run in xcode7 and xcode8
arm64 x86_64 armv7 armv7s 

1. gas-preprocessor.pl
copy `gas-preprocessor.pl` to /usr/local/bin, config permission  
gas-preprocessor.pl was download from https://github.com/yuvi/gas-preprocessor

    ```shell
    sudo cp -f gas-preprocessor.pl /usr/local/bin/
    chmod +x /usr/bin/gas-preprocessor.pl
    ```
2. build-ios-x264.sh
set SOURCE:x264 path, FAT: fat lib output path, THIN: libs outputpath
./build-ios-x264.sh

3. build-ios-ffmpeg.sh
set SOURCE:ffmpeg path, X264: x264 library, FAT: fat lib output path, THIN: libs output path
./build-ios-ffmpeg.sh

###android
NDK13
armeabi-v7a arm64-v8a x86_64 x86

1. edit build_android_x264.sh
set NDK, PREFIX_DIR output directory, SOURCE:x264 source directory
./build_android_x264_all.sh

2. edit ffmpeg/configure
For the output format like this libavcodec-55.so, which is accepted in Android. You need to edit ffmpeg/configure as follow:  
Find these codes:  

  ```
  SLIBNAME_WITH_MAJOR='$(SLIBNAME).$(LIBMAJOR)'
  LIB_INSTALL_EXTRA_CMD='＄＄(RANLIB) "$(LIBDIR)/$(LIBNAME)"'
  SLIB_INSTALL_NAME='$(SLIBNAME_WITH_VERSION)'
  SLIB_INSTALL_LINKS='$(SLIBNAME_WITH_MAJOR) $(SLIBNAME)'
  ```
  
 And modify into these ones:  
 
  ```
  SLIBNAME_WITH_MAJOR='$(SLIBPREF)$(FULLNAME)-$(LIBMAJOR)$(SLIBSUF)'
  LIB_INSTALL_EXTRA_CMD='＄＄(RANLIB)"$(LIBDIR)/$(LIBNAME)"'
  SLIB_INSTALL_NAME='$(SLIBNAME_WITH_MAJOR)'
  SLIB_INSTALL_LINKS='$(SLIBNAME)'
  ```



3. edit build_android_ffmpeg.sh
set NDK, OUTPUT_DIR, SOURCE: ffmpeg source directory, X264_DIR: x264 include and lib
./build_android_ffmpeg_all.sh


