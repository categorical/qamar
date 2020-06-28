#!/bin/bash

. `dirname $0`/env.sh
import 'out'


#readonly URI='http://downloads.xiph.org/releases/theora/libtheora-1.2.0alpha1.tar.xz'
readonly URI='http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.xz'
readonly DEST='/opt/lib/libtheora'
readonly LIBPNG15URI='ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng15/libpng-1.5.28.tar.xz'

_installlibpng15(){
    cachegetfile "$LIBPNG15URI" 'libpng15dest'
    pushd "$libpng15dest" >/dev/null||exit 1
    ./configure \
    --prefix="$libpng15dir" \
    && make \
    && make install \
    && find "$libpng15dir/lib" ! -name '*.a' -delete
    popd >/dev/null
}

_install(){

    cachegetfile "$URI" 'regdest'
    pushd "$regdest" >/dev/null||exit 1
    
    local -r libpng15dir="$(file::abspath './libpng15')"
    _installlibpng15

    PNG_CFLAGS="-I$libpng15dir/include/libpng15" \
    PNG_LIBS="-L$libpng15dir/lib -lpng15 -lz" \
    ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean \
    && make distclean
    popd >/dev/null
}

_install
linkpkgconfig


