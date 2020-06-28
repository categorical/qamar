#!/bin/bash

. `dirname $0`/env.sh
import 'out'

# Required by `GIMP 2.8.22`.

readonly URI='https://download.gimp.org/pub/gegl/0.2/gegl-0.2.0.tar.bz2'
readonly DEST='/opt/gnome/gegl2'

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
    linkpkgconfig 'gegl-0.2.pc'
    #linkbin 'gegl'

}

_remove()(
    :
    set -x
    sudo rm -R '/opt/gnome/gegl2'
    sudo rm '/opt/lib/pkgconfig/gegl-0.2.pc'
    rm -R "$SRCDIR/gegl-0.2.0"

)

case $1 in
    '--remove')_remove;;
    '--config')_config;;
    *)_install;_config;;
esac

