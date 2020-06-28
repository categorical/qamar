#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://downloads.sourceforge.net/project/libpng/libpng16/1.6.29/libpng-1.6.29.tar.xz'
readonly DEST='/opt/lib/libpng'

cachegetfile "$URI" 'regdest'


pushd "$regdest" >/dev/null
./configure \
--prefix="$DEST" \
--with-pkgconfigdir="$PKGCONFIGLIBDIR" \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null

