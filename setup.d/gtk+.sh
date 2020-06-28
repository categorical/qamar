#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='ftp://ftp.gnome.org/pub/gnome/sources/gtk+/3.91/gtk+-3.91.0.tar.xz'
readonly DEST='/opt/gnome/gtk+'

readonly GETTEXTDIR='/opt/gnu/gettext'

_install(){
    cachegetfile "$URI" 'regdest'

    pushd "$regdest" >/dev/null||exit 1
    
    CFLAGS="-I$GETTEXTDIR/include" \
    LDFLAGS="-L$GETTEXTDIR/lib" \
    ./configure \
    --prefix="$DEST" \
    --disable-x11-backend \
    --enable-quartz-backend \
    --disable-vulkan \
    --disable-win32-backend \
    && make -j3 \
    && sudo make install \
    && make clean
    popd >/dev/null

}

_config(){
    :
    linkpkgconfig \
        'gtk+-4.0.pc'

}

case $1 in
    '--config')_config;;
    *)_install;_config;;
esac


