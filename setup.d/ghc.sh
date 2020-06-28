#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='https://downloads.haskell.org/~ghc/8.0.2/ghc-8.0.2-src.tar.xz'
readonly DEST='/opt/ghc'

readonly BOOTSTRAPURI='https://downloads.haskell.org/~ghc/8.0.2/ghc-8.0.2-x86_64-apple-darwin.tar.xz'

_installbootstrap(){
    cachegetfile "$BOOTSTRAPURI" 'bootstrapunpacked'
    pushd "$bootstrapunpacked" >/dev/null||exit 1
    
    [ -d "$bootstrapdir" ]||exit 1
    ./configure \
    --prefix="$bootstrapdir" \
    && make install

    popd >/dev/null
    (set -x;rm -Rf "$bootstrapunpacked") 

}


_install(){

    cachegetfile "$URI" 'regdest'

    pushd "$regdest" 1>/dev/null||exit 1
    
    local -r bootstrapdir="$(file::mktempdir)"
    _installbootstrap
    
    ./configure \
    --prefix="$DEST" \
    --with-ghc="$bootstrapdir/bin/ghc" \
    && make -j5 \
    && sudo make install \
    && make clean \
    && make distclean    

    (set -x;rm -Rf "$bootstrapdir")
    popd 1>/dev/null

}

_remove()(
    :
    set -x
    #sudo rm -R /opt/ghc
    rm -R "$SRCDIR/ghc-8.0.2-src"

)

_config(){
    :
    linkbin 'ghc'
    linkbin 'ghci'
    linkbin 'ghc-pkg'
    linkbin 'haddock'

}


case $1 in
    '--config')_config;;
    '--remove')_remove;;
    *)_install;_config;;
esac

