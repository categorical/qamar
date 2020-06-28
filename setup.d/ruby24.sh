#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'


readonly URI='https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.1.tar.gz'
readonly DEST='/opt/ruby24'

_install(){
    cachegetfile "$URI" 'regdest'
    pushd "$regdest" >/dev/null
    
    ./configure \
    --prefix="$DEST" \
    && make -j5 \
    && sudo make install \
    && make clean \
    && make distclean
    popd >/dev/null
}


_config(){
    :
    linkbin 'ruby'
    linkbin 'gem'
    linkbin 'irb'

}

[ "$1" == '--config' ]||_install;_config


