#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://bitbucket.org/multicoreware/x265/downloads/x265_2.4.tar.gz'
readonly DEST='/opt/lib/x265'
readonly YASMDIR='/opt/yasm'

_install(){
    cachegetfile "$URI" 'regdest'
    PATH="$YASMDIR/bin:$PATH"
    cmakeminimal "$regdest/source"
}

_config(){
    dylibabspath "$DEST/bin" "$DEST/lib"
    linkpkgconfig
}

[ "$1" == '--config' ]||_install;_config

