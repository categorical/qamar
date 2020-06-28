#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='http://www.exiv2.org/builds/exiv2-0.26-trunk.tar.gz'
readonly DEST='/opt/lib/exiv2'

_install(){
    cachegetfile "$URI" 'regdest'

    (cd "$regdest" \
        && ./configure \
        --prefix="$DEST" \
        && make -j2 \
        && sudo make install \
        && make clean\
        && make distclean)
    [ -d "$regdest" ] && rm -Rf "$regdest"

}

_config(){
    linkpkgconfig

}

[ "$1" == '--config' ]||_install;_config


