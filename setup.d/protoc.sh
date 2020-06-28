#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'strings'

readonly URI='https://github.com/google/protobuf/archive/v3.3.0.tar.gz'
readonly DEST='/opt/protoc'

readonly LIBTOOLDIR='/opt/gnu/libtool'
cachegetfile "$URI" 'regdest'
pushd "$regdest" >/dev/null||exit 1
f='./autogen.sh'
l='autoreconf'
p=" -I '$LIBTOOLDIR/share/aclocal'"
sed -i "s/^$(strings::escapebresed "$l").*\$/&$(strings::escapesed "$p")/" "$f"

./autogen.sh \
&& ./configure \
--prefix="$DEST" \
&& make -j5 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null

linkbin 'protoc'

