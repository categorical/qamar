#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://ffmpeg.org/releases/ffmpeg-3.3.tar.xz'
readonly DEST='/opt/ffmpeg'


readonly YASMDIR='/opt/yasm'
readonly LIBGSMDIR='/opt/lib/libgsm'
readonly LIBMP3LAMEDIR='/opt/lib/libmp3lame'
readonly OPENCOREAMRDIR='/opt/lib/opencoreamr'
readonly SOXRDIR='/opt/lib/soxr'
readonly LIBTHEORADIR='/opt/lib/libtheora'
readonly LIBOGGDIR='/opt/lib/libogg'
readonly VOAMRWBENCDIR='/opt/lib/voamrwbenc'
readonly LIBVORBISDIR='/opt/lib/libvorbis'
readonly WAVPACKDIR='/opt/lib/wavpack'
readonly XAVSDIR='/opt/lib/xavs'
readonly XVIDDIR='/opt/lib/xvid'

readonly X265DIR='/opt/lib/x265'
readonly VIDSTABDIR='/opt/lib/vidstab'

_install(){
    cachegetfile "$URI" 'regdest'
    
    PATH="$YASMDIR/bin:$PATH"
    pushd "$regdest" >/dev/null||exit 1
    CFLAGS="\
    -I$XVIDDIR/include \
    -I$XAVSDIR/include \
    -I$WAVPACKDIR/include \
    -I$LIBVORBISDIR/include \
    -I$VOAMRWBENCDIR/include \
    -I$LIBTHEORADIR/include -I$LIBOGGDIR/include \
    -I$SOXRDIR/include \
    -I$OPENCOREAMRDIR/include \
    -I$LIBGSMDIR/inc \
    -I$LIBMP3LAMEDIR/include" \
    LDFLAGS="\
    -L$XVIDDIR/lib \
    -L$XAVSDIR/lib \
    -L$WAVPACKDIR/lib \
    -L$LIBVORBISDIR/lib \
    -L$VOAMRWBENCDIR/lib \
    -L$LIBTHEORADIR/lib -L$LIBOGGDIR/lib \
    -L$SOXRDIR/lib \
    -L$OPENCOREAMRDIR/lib \
    -L$LIBGSMDIR/lib \
    -L$LIBMP3LAMEDIR/lib" \
    ./configure \
    --prefix="$DEST" \
    --cc=/usr/bin/clang \
    --as=yasm \
    --enable-avisynth \
    --enable-fontconfig \
    --enable-gpl \
    --enable-libass \
    --enable-libbluray \
    --enable-libfreetype \
    --enable-libmodplug \
    --enable-libgsm \
    --enable-libmp3lame \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
    --enable-libopus \
    --enable-libschroedinger \
    --enable-libsoxr \
    --enable-libspeex \
    --enable-libtheora \
    --enable-libvidstab \
    --enable-libvo-amrwbenc \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwavpack \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxavs \
    --enable-libxvid \
    --enable-libzmq \
    --enable-version3 \
    --disable-ffplay \
    --disable-indev=qtkit \
    && make -j2 \
    && sudo make install \
    && make clean\
    && make distclean
    popd >/dev/null
    #--enable-libvo-aacenc \
    #--disable-indev=x11grab_xcb \
}

_config(){
    :
    dylibabspath "$DEST/bin" "$X265DIR/lib" "$VIDSTABDIR/lib"
    linkbin 'ffprobe'
    linkbin 'ffmpeg'
}

[ "$1" == '--config' ]||_install;_config

