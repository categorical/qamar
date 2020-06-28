#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://isl.gforge.inria.fr/isl-0.18.tar.xz'
readonly DEST='/opt/lib/isl'

readonly GMPDIR='/opt/lib/gmp'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
--with-gmp-prefix="$GMPDIR" \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null

linkpkgconfig

