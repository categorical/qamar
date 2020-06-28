#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://github.com/emcrisostomo/fswatch/releases/download/1.9.3/fswatch-1.9.3.tar.gz'
readonly DEST='/opt/fswatch'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkbin 'fswatch'

