#!/bin/bash

. `dirname $0`/env.sh
import 'ftp' 'file'


readonly URI='https://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.bz2'
readonly DEST='/opt/gnu/binutils'


cachegetfile "$URI" 'regdest'


pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null

linkbin 'objdump'
linkbin 'objcopy'

