#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='ftp://ftp.cwru.edu/pub/bash/readline-7.0.tar.gz'
readonly DEST='/opt/lib/readline'
cachegetfile "$URI" 'regdest'

makeminimal "$regdest"


