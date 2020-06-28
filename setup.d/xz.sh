#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://tukaani.org/xz/xz-5.2.3.tar.xz'
readonly DEST='/opt/lib/xz'


cachegetfile "$URI" 'regdest'

(cd "$regdest" \
    && ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean\
    && make distclean)
linkpkgconfig 'liblzma.pc'

