#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://github.com/mypaint/libmypaint/releases/download/v1.3.0/libmypaint-1.3.0.tar.xz'
readonly DEST='/opt/lib/libmypaint'

readonly GETTEXTDIR='/opt/gnu/gettext'

_install(){
    cachegetfile "$URI" 'regdest'

    (cd "$regdest" \
        && \
        CFLAGS="-I$GETTEXTDIR/include" \
        LDFLAGS="-L$GETTEXTDIR/lib" \
        ./configure \
        --prefix="$DEST" \
        && make -j2 \
        && sudo make install \
        && make clean\
        && make distclean)

}

_config(){
    linkpkgconfig

}

[ "$1" == '--config' ]||_install;_config


