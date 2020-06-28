#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'


readonly DEST='/opt/nodemodules/gulp'

readonly NPM='/opt/nodejs/bin/npm'
readonly ITEM='gulp'

_nodeinstall(){
    local t="$1"
    (cd "$t" && "$NPM" install "$ITEM" --prefix=. -g 2>/dev/null)
   
    sudo mkdir -p "$DEST" \
        && (cd "$DEST" \
        && { set -x;sudo cp -R "$t"/* .;})
}



_install(){
    file::withtempdir '_nodeinstall'
}

_config(){
    linkbin 'gulp'
}

[ "$1" == '--config' ]||_install;_config
