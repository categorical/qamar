#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz'
readonly DEST='/opt/lib/libxml2'

_install(){
    cachegetfile "$URI" 'regdest'
    makeminimal "$regdest"
}

_config(){
    linkpkgconfig
    linkbin 'xmlcatalog'
}

[ "$1" == '--config' ]||_install;_config

