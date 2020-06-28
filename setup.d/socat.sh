#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='http://www.dest-unreach.org/socat/download/socat-1.7.3.2.tar.bz2'
readonly DEST='/opt/socat'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkbin 'socat'


