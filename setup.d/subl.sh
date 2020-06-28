#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='https://download.sublimetext.com/Sublime%20Text%20Build%203126.dmg'

_install(){
    _getfile(){
        http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
    }
    cacheget "$URI" '_getfile' 'regdest'
    file::installdmg "$regdest"
}

_config(){
    :
    bindir='/Applications/Sublime Text.app/Contents/SharedSupport/bin'    
    linkbin "$bindir/subl"
}

[ "$1" == '--config' ]||_install;_config

