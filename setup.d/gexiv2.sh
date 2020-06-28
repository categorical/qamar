#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='ftp://ftp.gnome.org/pub/gnome/sources/gexiv2/0.10/gexiv2-0.10.6.tar.xz'
readonly DEST='/opt/gnome/gexiv2'


cachegetfile "$URI" 'regdest'

(cd "$regdest" \
    && ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean\
    && make distclean)

#--enable-introspection \


linkpkgconfig 'gexiv2.pc'

