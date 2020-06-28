#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='https://www.cairographics.org/releases/pixman-0.34.0.tar.gz'
readonly DEST='/opt/gnome/pixman'

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
    linkpkgconfig
}

case $1 in
    '--config')_config;;
    *)_install;_config;;
esac


