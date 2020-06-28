#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://github.com/git/git/archive/v2.12.2.tar.gz'
readonly DEST='/opt/git'

cachegetfile "$URI" 'regdest'

readonly SSLDIR='/opt/openssl'
readonly CURLDIR='/opt/curl'

pushd "$regdest" >/dev/null||exit 1
make configure \
&& ./configure \
--prefix="$DEST" \
--with-openssl="$SSLDIR" \
--with-curl="$CURLDIR" \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null

linkbin 'git'


