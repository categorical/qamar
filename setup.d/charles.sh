#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='https://www.charlesproxy.com/assets/release/4.1.2/charles-proxy-4.1.2.dmg'

_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}
cacheget "$URI" '_getfile' 'regdest'

file::installdmg "$regdest"

