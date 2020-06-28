#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='http://dl.maptools.org/dl/libtiff/tiff-3.8.2.tar.gz'
readonly DEST='/opt/lib/libtiff'

cachegetfile "$URI" 'regdest'

(cd "$regdest" \
    && ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean\
    && make distclean)


