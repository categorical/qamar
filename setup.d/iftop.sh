#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='http://www.ex-parrot.com/pdw/iftop/download/iftop-1.0pre4.tar.gz'
readonly DEST='/opt/iftop'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkbin "$DEST/sbin/iftop"


