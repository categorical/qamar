#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='https://www.cairographics.org/snapshots/cairo-1.15.4.tar.xz'
readonly DEST='/opt/gnome/cairo'

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
        'cairo.pc' \
        'cairo-gobject.pc' \
        'cairo-ft.pc' \
        'cairo-quartz-font.pc' \
        'cairo-quartz.pc'
 
}

case $1 in
    '--config')_config;;
    *)_install;_config;;
esac


