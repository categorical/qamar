#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://download.gimp.org/pub/gegl/0.3/gegl-0.3.18.tar.bz2'
readonly DEST='/opt/gnome/gegl'

readonly GETTEXTDIR='/opt/gnu/gettext'
readonly LIBJPEGDIR='/opt/lib/libjpeg'
readonly PYTHON2='/opt/python27/bin/python2'

_install(){
    cachegetfile "$URI" 'regdest'

    (cd "$regdest" \
        && \
        PYTHON="$PYTHON2" \
        CPPFLAGS=" \
        -I$LIBJPEGDIR/include \
        -I$GETTEXTDIR/include \
        " \
        LDFLAGS=" \
        -L$LIBJPEGDIR/lib \
        -L$GETTEXTDIR/lib \
        " \
        ./configure \
        --prefix="$DEST" \
        && make -j2 \
        && sudo make install \
        && make clean\
        && make distclean)

}

_config(){
    linkpkgconfig 'gegl-0.3.pc'
    linkbin 'gegl'

}


[ "$1" == '--config' ]||_install;_config

