#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://cmake.org/files/v3.8/cmake-3.8.0.tar.gz'
readonly DEST='/opt/cmake'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null
./configure \
--prefix="$DEST" \
&& make -j2 \
&& sudo make install \
&& make clean
popd >/dev/null

linkbin 'cmake'

