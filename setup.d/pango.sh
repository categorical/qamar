#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='ftp://ftp.gnome.org/pub/gnome/sources/pango/1.40/pango-1.40.6.tar.xz'
readonly DEST='/opt/gnome/pango'

_install(){
    cachegetfile "$URI" 'regdest'
    
    pushd "$regdest" >/dev/null||exit 1
    ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean
    popd >/dev/null

}

_config(){
    :
    linkpkgconfig \
        'pango.pc' \
        'pangocairo.pc' \
        'pangoft2.pc'

}

case $1 in
    '--config')_config;;
    *)_install;_config;;
esac


