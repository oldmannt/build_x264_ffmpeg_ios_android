# build_x264_ffmpeg_ios_android
my pc: macOS 10.12
x264: x264-0.148.r2705 www.videolan.org/developers/x264.html
ffmpeg: 3.1.1 https://github.com/FFmpeg/FFmpeg

###ios
xcode7
arm64 x86_64 armv7 armv7s 

###android
NDK13
armeabi-v7a arm64-v8a x86_64 x86

Find these codes:  

  SLIBNAME_WITH_MAJOR='$(SLIBNAME).$(LIBMAJOR)'
  LIB_INSTALL_EXTRA_CMD='＄＄(RANLIB) "$(LIBDIR)/$(LIBNAME)"'
  SLIB_INSTALL_NAME='$(SLIBNAME_WITH_VERSION)'
  SLIB_INSTALL_LINKS='$(SLIBNAME_WITH_MAJOR) $(SLIBNAME)'

  
 And modify into these ones:  
 
  SLIBNAME_WITH_MAJOR='$(SLIBPREF)$(FULLNAME)-$(LIBMAJOR)$(SLIBSUF)'
  LIB_INSTALL_EXTRA_CMD='＄＄(RANLIB)"$(LIBDIR)/$(LIBNAME)"'
  SLIB_INSTALL_NAME='$(SLIBNAME_WITH_MAJOR)'
  SLIB_INSTALL_LINKS='$(SLIBNAME)'

build_android_all.sh
set NDK, PREFIX_DIR output directory, SOURCE:x264 srouce directory
./build_android_all.sh

