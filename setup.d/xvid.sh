#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz'
readonly DEST='/opt/lib/xvid'
readonly YASMDIR='/opt/yasm'

cachegetfile "$URI" 'regdest'
PATH="$YASMDIR/bin:$PATH"
makeminimal "$regdest/build/generic"

