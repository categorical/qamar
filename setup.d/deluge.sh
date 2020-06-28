#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='http://download.deluge-torrent.org/mac_osx/deluge-1.3.15.1-macosx-x64.dmg'

_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}
cacheget "$URI" '_getfile' 'regdest'

file::installdmg "$regdest"

