#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'


readonly URI='https://download.mozilla.org/?product=firefox-52.0.2-SSL&os=osx&lang=en-GB'

_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}
cacheget "$URI" '_getfile' 'regdest'

file::installdmg "$regdest"


