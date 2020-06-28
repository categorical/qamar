#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20170510-2245-stable.tar.bz2'
readonly DEST='/opt/lib/x264'
readonly YASMDIR='/opt/yasm'

PATH="$YASMDIR/bin:$PATH"
cachegetfile "$URI" 'regdest'
pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
--enable-static \
--enable-shared \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null

linkpkgconfig

