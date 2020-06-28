#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2'
readonly DEST='/opt/lib/pcre'

cachegetfile "$URI" 'regdest'

(cd "$regdest" \
    && ./configure \
        --prefix="$DEST" \
        --enable-unicode-properties \
    && make -j2 \
    && sudo make install \
    && make clean\
    && make distclean)

linkpkgconfig

