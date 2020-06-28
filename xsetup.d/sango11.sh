#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

DISTFILE="$HOME/xdev/sango11/dist/sango11.app.tar.gz"


_install(){
    file::installzip "$DISTFILE"
}

_remove()(
    set -x
    rm -R '/Applications/sango11.app'
    #rm -R "$HOME/Documents/Koei"
)

case $1 in
    '--install')_install;;
    '--remove')_remove;;
    *);;
esac



