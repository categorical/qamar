#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'http'

readonly URI='https://curl.haxx.se/ca/cacert.pem'
readonly DEST='/usr/local/etc/ssl'

_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}
cacheget "$URI" '_getfile' 'regdest'
sudo mkdir -p "$DEST"
sudo cp "$regdest" "$DEST/cacert.pem"


