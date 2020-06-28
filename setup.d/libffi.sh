#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz'
readonly DEST='/opt/lib/libffi'

cachegetfile "$URI" 'regdest'

(cd "$regdest" \
    && ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean\
    && make distclean)

linkpkgconfig

