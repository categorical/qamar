#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='https://iterm2.com/downloads/stable/iTerm2-3_0_15.zip'


_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}
cacheget "$URI" '_getfile' 'regdest'

file::installzip "$regdest"


