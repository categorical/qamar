#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz'
readonly DEST='/opt/yasm'

cachegetfile "$URI" 'regdest'

readonly PYTHON2=/opt/python27/bin/python2

pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
PYTHON="$PYTHON2" \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null


