#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://curl.haxx.se/download/curl-7.53.1.tar.gz'
readonly DEST='/opt/curl'

cachegetfile "$URI" 'regdest'

readonly SSLDIR='/opt/openssl'
readonly NGHTTP2DIR='/opt/lib/nghttp2'
readonly CAFILE='/usr/local/etc/ssl/cacert.pem'

pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
--with-ssl="$SSLDIR" \
--with-ca-bundle="$CAFILE" \
--with-nghttp2="$NGHTTP2DIR" \
--enable-symbol-hiding \
--enable-threaded-resolver \
--with-gssapi \
--without-libssh2 \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
#--with-darwinssl \
popd >/dev/null

linkpkgconfig
linkbin 'curl'


