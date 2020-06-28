#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='https://storage.googleapis.com/golang/go1.8.1.src.tar.gz'
readonly DEST='/opt/golang18'

# link: https://github.com/golang/go/issues/16352
readonly GOLANG14URI='https://storage.googleapis.com/golang/go1.4-bootstrap-20161024.tar.gz'

unset GOROOT GOROOT_FINAL GOPATH

_installbootstrap(){
    cachegetfile "$GOLANG14URI" 'golang14dest'
    pushd "$golang14dest/src" >/dev/null||exit 1
    GOROOT_FINAL="$bootstrapdir" ./make.bash
    popd >/dev/null
    (set -x;cd "$golang14dest" && cp -R bin src pkg "$bootstrapdir")
    (set -x;rm -Rf "$golang14dest")
}

_install(){
    cachegetfile "$URI" 'regdest'
    pushd "$regdest/src" >/dev/null||exit 1
    local -r bootstrapdir="$(file::mktempdir)"
    _installbootstrap

    GOROOT_BOOTSTRAP="$bootstrapdir" \
    GOROOT_FINAL="$DEST" \
    ./all.bash
    (set -x;rm -Rf "$bootstrapdir")
    popd >/dev/null
     
    (set -x;sudo mkdir -p "$DEST" && sudo cp -R "$regdest"/* "$DEST")
    (set -x;rm -Rf "$regdest")
}

_config(){
    :
    linkbin 'go'
    linkbin 'gofmt'
    setenv 'GOPATH' '$HOME/godev'
}

[ "$1" == '--config' ]||_install;_config


