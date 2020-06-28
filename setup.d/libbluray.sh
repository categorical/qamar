#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='ftp://ftp.videolan.org/pub/videolan/libbluray/1.0.0/libbluray-1.0.0.tar.bz2'
readonly DEST='/opt/lib/libbluray'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
&& make -j2 \
&& sudo -E make install \
&& make clean\
&& make distclean
popd >/dev/null

linkpkgconfig


