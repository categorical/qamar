#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://download.gimp.org/pub/babl/0.1/babl-0.1.28.tar.bz2'
readonly DEST='/opt/gnome/babl'


cachegetfile "$URI" 'regdest'

(cd "$regdest" \
    && ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean\
    && make distclean)
linkpkgconfig

