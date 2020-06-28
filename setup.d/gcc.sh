#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://nl.mirror.babylon.network/gcc/releases/gcc-7.1.0/gcc-7.1.0.tar.bz2'
readonly DEST='/opt/gcc'

readonly GMPDIR='/opt/lib/gmp'
readonly MPFRDIR='/opt/lib/mpfr'
readonly MPCDIR='/opt/lib/mpc'
readonly ISLDIR='/opt/lib/isl'

_install(){
    cachegetfile "$URI" 'regdest'

    pushd "$regdest" >/dev/null||exit 1
    ./configure \
    --prefix="$DEST" \
    --with-gmp="$GMPDIR" \
    --with-mpfr="$MPFRDIR" \
    --with-mpc="$MPCDIR" \
    --with-isl="$ISLDIR" \
    --enable-languages='c,c++,fortran,objc,obj-c++' \
    && make -j5 \
    && sudo make install \
    && make clean\
    && make distclean
    popd >/dev/null
}

_config(){
    :
}

[ "$1" == '--config' ]||_install;_config

