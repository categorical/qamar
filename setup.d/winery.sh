#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='https://vorboss.dl.sourceforge.net/project/wineskin/Wineskin%20Winery.app%20Version%201.7.zip'

_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}

_install(){
    cacheget "$URI" '_getfile' 'regdest'

    file::installzip "$regdest"
}

_remove()(
    set -x
    rm -R '/Applications/Wineskin Winery.app'
    rm -R "$HOME/Applications/Wineskin"
    rm -R "$HOME/Library/Caches/com.urgesoftware.wineskin.wineskinwinery"
    rm -R "$HOME/Library/Application Support/Wineskin"
    rm -R "$HOME/Library/Caches/Wine"
    rm -R "$HOME/.local"
    #rm -R "$HOME/.cache"
)

case $1 in
    '--remove')_remove;;
    *)_install;;
esac



