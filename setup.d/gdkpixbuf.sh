#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.6.tar.xz'
readonly DEST='/opt/gnome/gdkpixbuf'

readonly GETTEXTDIR='/opt/gnu/gettext'
readonly LIBTIFFDIR='/opt/lib/libtiff'
readonly LIBJPEGDIR='/opt/lib/libjpeg'

_install(){
    cachegetfile "$URI" 'regdest'
    
    pushd "$regdest" >/dev/null||exit 1
    CPPFLAGS=" \
    -I$GETTEXTDIR/include \
    -I$LIBJPEGDIR/include \
    -I$LIBTIFFDIR/include \
    " \
    LDFLAGS=" \
    -L$GETTEXTDIR/lib \
    -L$LIBJPEGDIR/lib \
    -L$LIBTIFFDIR/lib \
    " \
    ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean
    popd >/dev/null

}

_config(){
    :
    linkpkgconfig
    linkbin 'gdk-pixbuf-csource'
    linkbin 'gdk-pixbuf-pixdata'
}

case $1 in
    '--config')_config;;
    *)_install;_config;;
esac


