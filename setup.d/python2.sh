#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'


readonly URI='https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz'
readonly DEST='/opt/python27'

readonly SSLDIR='/opt/openssl'

cachegetfile "$URI" 'regdest'


pushd "$regdest" >/dev/null
CPPFLAGS="-I$SSLDIR/include" \
LDFLAGS="-L$SSLDIR/lib" \
./configure \
--prefix="$DEST" \
--enable-ipv6 \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null

linkbin 'python2.7' 'python2'
linkbin 'python2.7-config' 'python2-config'

# installs pip.
readonly PIPURI='https://bootstrap.pypa.io/get-pip.py'
_getpip(){
    http::downloadfile "$PIPURI" "$DISTDIR" 'nil' 'regdest'||exit 1
}
cacheget "$PIPURI" '_getpip' 'regdest'
[ -z "$regdest" ]||sudo "$DEST/bin/python2.7" "$regdest"
linkbin 'pip2.7' 'pip2'
copyuserconfig 'pip/pip.conf' '.pip/pip.conf'
# When using pip with sudo, it looks for (per user) config file at $HOME/.pip/pip.conf,
# and the default directory (used when config file does not exist) for download cache is $HOME/Library/Caches/pip;
# therefore, sudo pip will most likely use a directory owned by the current user for cache, and thus a warning.
# Using sudo -H sets $HOME to /var/root, which eliminates the warning,
# but expects maintaining a global config file at /Library/Application\ Support/pip/pip.conf.
# Alternatively, --no-cache-dir disables using the cache,
# but happens not before running get-pip.py (which also generates the warning).
# 

# installs virtualenv.
sudo "$DEST/bin/pip2.7" '--no-cache-dir' install 'virtualenv'
linkbin 'virtualenv' 'virtualenv2'




