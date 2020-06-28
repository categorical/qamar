#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://www.openssl.org/source/openssl-1.1.0e.tar.gz'
readonly DEST='/opt/openssl'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null
./Configure \
darwin64-x86_64-cc \
enable-ec_nistp_64_gcc_128 \
no-ssl3 \
--prefix="$DEST" \
&& make depend \
&& sudo make install \
&& make clean \
&& make distclean
popd >/dev/null

linkpkgconfig
linkbin 'openssl'

