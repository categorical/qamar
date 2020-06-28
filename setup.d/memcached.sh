#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://www.memcached.org/files/memcached-1.4.36.tar.gz'
readonly DEST='/opt/memcached'

readonly LIBEVENTDIR='/opt/lib/libevent'

_install(){
    cachegetfile "$URI" 'regdest'

    pushd "$regdest" >/dev/null
    ./configure \
    --prefix="$DEST" \
    --with-libevent="$LIBEVENTDIR" \
    && make -j2 \
    && sudo make install \
    && make clean\
    && make distclean
    popd >/dev/null
}

_config(){
    adduser '_memcached'
    sudo mkdir -p '/var/log/memcached'
    copyconfig 'memcached/memcached.plist' '/Library/LaunchDaemons' \
        && sudo chown root:wheel '/Library/LaunchDaemons/memcached.plist'
    copyuserconfig 'memcached/memcachedctl.sh' '.bashctl.d'
}

[ "$1" == '--config' ]||_install;_config



