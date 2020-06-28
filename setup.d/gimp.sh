#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly DEST='/opt/gimp'
#readonly URI='ftp://ftp.mirrorservice.org/sites/ftp.gimp.org/pub/gimp/v2.9/gimp-2.9.4.tar.bz2'
readonly URI='ftp://ftp.mirrorservice.org/sites/ftp.gimp.org/pub/gimp/v2.8/gimp-2.8.22.tar.bz2'

readonly GETTEXTDIR='/opt/gnu/gettext'
readonly LIBTIFFDIR='/opt/lib/libtiff'
readonly LIBJPEGDIR='/opt/lib/libjpeg'
readonly CAIRODIR='/opt/gnome/cairo'

_install(){
    cachegetfile "$URI" 'regdest'

    pushd "$regdest" >/dev/null||exit 1

    CPPFLAGS=" \
    -I$GETTEXTDIR/include \
    -I$LIBJPEGDIR/include \
    -I$LIBTIFFDIR/include \
    -I$CAIRODIR/include \
    " \
    LDFLAGS=" \
    -L$GETTEXTDIR/lib \
    -L$LIBJPEGDIR/lib \
    -L$LIBTIFFDIR/lib \
    -L$CAIRODIR/lib \
    " \
    ./configure \
    --prefix="$DEST" \
    --disable-python \
    && make -j5 \
    && sudo make install \
    && make clean
    popd >/dev/null

}

_config(){
    :
    sudo rm '/usr/local/bin/gimp'
    copyconfig 'gimp/gimp.delegate' '/usr/local/bin/gimp'    

}

_remove()(
    :
    set -x
    sudo rm -R '/opt/gimp'
    sudo rm '/usr/local/bin/gimp'
    rm -R "$SRCDIR/gimp-2.9.4"
    rm -R "$SRCDIR/gimp-2.8.22"

)

case $1 in
    '--remove')_remove;;
    '--config')_config;;
    *)_install;_config;;
esac


