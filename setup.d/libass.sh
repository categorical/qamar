#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://github.com/libass/libass/releases/download/0.13.6/libass-0.13.6.tar.xz'
readonly DEST='/opt/lib/libass'

cachegetfile "$URI" 'regdest'

readonly PKGCONFIGDIR='/opt/pkgconfig'

pushd "$regdest" >/dev/null
autoreconf -ivf -I "$PKGCONFIGDIR"/share/aclocal \
&& ./configure \
--prefix="$DEST" \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null

linkpkgconfig
