#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://pkg-config.freedesktop.org/releases/pkg-config-0.29.1.tar.gz'
readonly DEST='/opt/pkgconfig'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null
./configure \
--prefix="$DEST" \
--with-pc-path="$PKGCONFIGLIBDIR" \
--with-internal-glib \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null


linkpkgconfig
linkbin 'pkg-config'
