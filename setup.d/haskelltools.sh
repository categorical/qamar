#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly DEST='/opt/haskelltools'

_installstack(){
    sudo -k
    readonly STACKURI='https://github.com/commercialhaskell/stack/releases/download/v1.4.0/stack-1.4.0-osx-x86_64.tar.gz'
    cachegetfile "$STACKURI" 'stackunpacked'
    ITEM='stack'
    (cd "$stackunpacked" \
        && sudo mkdir -p "$DEST/bin" \
        && sudo cp "$ITEM" "$DEST/bin" \
        &&{ set -x;rm -R "$stackunpacked";})
    linkbin "$ITEM"
    out::info "$(printf 'installed: %s.' "$ITEM")"

}

_removestack()(
    :
    set -x
    sudo rm '/usr/local/bin/stack'
    sudo rm -R '/opt/haskelltools/bin/stack'
    rm -R "$HOME/.stack"

)

_installcabaltool(){
    :
    sudo -k
    readonly CABALTOOLURI='https://www.haskell.org/cabal/release/cabal-install-1.24.0.2/cabal-install-1.24.0.2.tar.gz'
    cachegetfile "$CABALTOOLURI" 'cabaltoolunpacked'

    ITEM='cabal'
    (set -x;rm -R "$HOME/.ghc")
    local -r t="$(file::mktempdir)"    
    (cd "$cabaltoolunpacked" \
        && PREFIX="$t" ./bootstrap.sh \
        && sudo mkdir -p "$DEST/bin" \
        && sudo cp "$t/bin/$ITEM" "$DEST/bin")
    (set -x;rm -R "$t")
    (set -x;rm -R "$HOME/.ghc")
    
    linkbin "$ITEM"
    out::info "$(printf 'installed: %s.' "$ITEM")"

}

_removecabaltool()(
    :
    set -x
    sudo rm '/usr/local/bin/cabal'
    sudo rm -R '/opt/haskelltools/bin/cabal'
    

)


_install(){
    _installstack
    _installcabaltool

}

_remove(){
    :
    _removestack
    _removecabaltool

}

case $1 in
    '--remove')_remove;;
    *)_install;;
esac


