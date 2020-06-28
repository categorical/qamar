#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='ftp://ftp.gnome.org/pub/gnome/sources/atk/2.25/atk-2.25.2.tar.xz'
readonly DEST='/opt/gnome/atk'

readonly GETTEXTDIR='/opt/gnu/gettext'

_install(){
    cachegetfile "$URI" 'regdest'

    pushd "$regdest" >/dev/null||exit 1
    CFLAGS="-I$GETTEXTDIR/include" \
    LDFLAGS="-L$GETTEXTDIR/lib" \
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


