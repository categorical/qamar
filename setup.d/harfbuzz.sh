#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.4.6.tar.bz2'
readonly DEST='/opt/gnome/harfbuzz'

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
    sudo ln -sf "$DEST/lib/pkgconfig/harfbuzz.pc" "$PKGCONFIGLIBDIR"

}

case $1 in
    '--config')_config;;
    *)_install;_config;;
esac


