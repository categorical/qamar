#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://www.mpfr.org/mpfr-current/mpfr-3.1.5.tar.xz'
readonly DEST='/opt/lib/mpfr'

readonly GMPDIR='/opt/lib/gmp'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
--with-gmp="$GMPDIR" \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null



