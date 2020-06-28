#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'


readonly URI='https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz'
readonly DEST='/opt/python36'

readonly SSLDIR='/opt/openssl'

cachegetfile "$URI" 'regdest'
pushd "$regdest" >/dev/null||exit 1
CPPFLAGS="-I$SSLDIR/include" \
LDFLAGS="-L$SSLDIR/lib" \
./configure \
--prefix="$DEST" \
--enable-ipv6 \
&& make -j2 \
&& sudo make install \
&& make clean \
&& make distclean

(set -x;find . \
    -type d \
    -name '__pycache__' \
    -user root \
    -print0|xargs -0 sudo rm -R)

popd >/dev/null


linkbin 'python3.6' 'python3'
linkbin 'python3.6-config' 'python3-config'

readonly PIPURI='https://bootstrap.pypa.io/get-pip.py'
_getpip(){
    http::downloadfile "$PIPURI" "$DISTDIR" 'nil' 'regdest'||exit 1
}
cacheget "$PIPURI" '_getpip' 'regdest'
[ -z "$regdest" ]||sudo "$DEST/bin/python3.6" "$regdest"
linkbin 'pip3.6' 'pip3'
copyuserconfig 'pip/pip.conf' '.pip/pip.conf'


sudo "$DEST/bin/pip3.6" '--no-cache-dir' install 'virtualenv'
linkbin 'virtualenv' 'virtualenv3'



