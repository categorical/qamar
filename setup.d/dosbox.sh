#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='https://vorboss.dl.sourceforge.net/project/dosbox/dosbox/0.74/DOSBox-0.74-1_Universal.dmg'

_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}

_install(){
    cacheget "$URI" '_getfile' 'regdest'
    file::installdmg "$regdest"
}

_remove()(
    set -x
    rm -R '/Applications/DOSBox.app'
    rm "$HOME/Library/Preferences/DOSBox 0.74 Preferences"
)

case $1 in
    '--install')_install;;
    '--remove')_remove;;
    *);;
esac

