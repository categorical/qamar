#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'


readonly DEST='/opt/nodemodules/bower'

readonly NPM='/opt/nodejs/bin/npm'
readonly ITEM='bower'

_nodeinstall(){
    local t="$1"
    (cd "$t" && "$NPM" install "$ITEM" 2>/dev/null)
    
    local d="$(ls -d "$t"/node_modules/*|tail -n1)"
    
    if [ -d "$d" ];then
        d="$(file::abspath "$d")"
    else
        return 1
    fi
    
    sudo mkdir -p "$DEST" \
        && (cd "$DEST" \
        && { set -x;sudo cp -R "$d"/* .;})
}



_install(){
    file::withtempdir '_nodeinstall'
}

_config(){
    linkbin 'bower'
    copyuserconfig 'bower/bowerrc' '.bowerrc'
    
}

[ "$1" == '--config' ]||_install;_config
