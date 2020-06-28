#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://github.com/anholt/libepoxy/releases/download/1.4.3/libepoxy-1.4.3.tar.xz'
readonly DEST='/opt/lib/libepoxy'

cachegetfile "$URI" 'regdest'

(cd "$regdest" \
    && ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean\
    && make distclean)
linkpkgconfig

