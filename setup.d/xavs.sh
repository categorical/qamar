#!/bin/bash

# Implementation of AVS, a Chinese compression standard.

. `dirname $0`/env.sh
import 'out'

readonly URI='https://sourceforge.net/code-snapshots/svn/x/xa/xavs/code/xavs-code-55-trunk.zip'
readonly DEST='/opt/lib/xavs'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
--disable-asm \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null


