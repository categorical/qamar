#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'


readonly URI='https://downloads.lightbend.com/scala/2.12.2/scala-2.12.2.tgz'
readonly DEST='/opt/scala'

_install(){
    cachegetfile "$URI" 'regdest'
    (cd "$regdest" \
        && { set -x;sudo mkdir -p "$DEST" \
        && sudo cp -R ./* "$DEST";})
}

_config(){
    linkbin 'scala'
}

[ "$1" == '--config' ]||_install;_config


