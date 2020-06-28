#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'


readonly URI='https://github.com/GStreamer/orc/archive/orc-0.4.26.tar.gz'
readonly DEST='/opt/lib/orc'

readonly LIBTOOLDIR='/opt/gnu/libtool'

_install(){
    cachegetfile "$URI" 'regdest'
    pushd "$regdest" >/dev/null||exit 1
    autoreconf -ivf -I "$LIBTOOLDIR/share/aclocal" \
    && ./configure \
    --prefix="$DEST" \
    && make -j2\
    && sudo make install \
    && make clean \
    && make distclean
    popd >/dev/null
}
_install

linkpkgconfig


