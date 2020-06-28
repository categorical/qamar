#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'


readonly URI='https://www.araelium.com/querious/downloads/Querious.dmg'

_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}
cacheget "$URI" '_getfile' 'regdest'

file::installdmg "$regdest"


