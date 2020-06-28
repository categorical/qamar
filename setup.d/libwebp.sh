#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-0.6.0.tar.gz'
readonly DEST='/opt/lib/libwebp'

readonly LIBPNGDIR='/opt/lib/libpng'
readonly LIBJPEGDIR='/opt/lib/libjpeg'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
--with-pngincludedir="$LIBPNGDIR/include" \
--with-pnglibdir="$LIBPNGDIR/lib" \
--with-jpegincludedir="$LIBJPEGDIR/include" \
--with-jpeglibdir="$LIBJPEGDIR/lib" \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null

linkpkgconfig

