#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg'

_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}
cacheget "$URI" '_getfile' 'regdest'

file::installdmg "$regdest"

