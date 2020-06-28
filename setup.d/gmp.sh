#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz'
readonly DEST='/opt/lib/gmp'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
--enable-cxx \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null



