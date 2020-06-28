#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://vorboss.dl.sourceforge.net/project/lcms/lcms/2.8/lcms2-2.8.tar.gz'
readonly DEST='/opt/lib/lcms2'

_install(){
    cachegetfile "$URI" 'regdest'

    (cd "$regdest" \
        && ./configure \
        --prefix="$DEST" \
        && make -j2 \
        && sudo make install \
        && make clean\
        && make distclean)

}

_config(){
    linkpkgconfig

}

[ "$1" == '--config' ]||_install;_config


