#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz'
readonly DEST='/opt/lib/libevent'
readonly SSLDIR='/opt/openssl'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
CPPFLAGS="-I$SSLDIR/include" \
LDFLAGS="-L$SSLDIR/lib" \
./configure \
--prefix="$DEST" \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null

linkpkgconfig


