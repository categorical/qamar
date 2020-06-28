#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='http://buy.parallels.com/329/pl/112516196-m6od0OfMYpdQbPFWBPzO-1-2-1'

_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}
cacheget "$URI" '_getfile' 'regdest'

_installmanual(){
    local item='Install.app'    
    if [ -d "$item" ];then
        open -W "$item"
    fi
}

_remove()(
    set -x
    sudo rm -R '/Applications/Parallels Desktop.app'
    rm -R "$HOME/Applications (Parallels)"
         
)

_detach(){
    hdiutil detach '/Volumes/Parallels Desktop 12'
}

case $1 in
    '--install')
        file::withdmg "$regdest" '_installmanual';;
    '--remove')_remove;;
    '--detach')_detach;;
    *);;
esac


