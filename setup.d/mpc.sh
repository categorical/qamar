#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz'
readonly DEST='/opt/lib/mpc'

readonly GMPDIR='/opt/lib/gmp'
readonly MPFRDIR='/opt/lib/mpfr'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
--with-gmp="$GMPDIR" \
--with-mpfr="$MPFRDIR" \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null



