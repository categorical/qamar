#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='ftp://ftp.gnome.org/pub/gnome/sources/json-glib/1.2/json-glib-1.2.8.tar.xz'
readonly DEST='/opt/gnome/jsonglib'

readonly GETTEXTDIR='/opt/gnu/gettext'

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
linkpkgconfig

