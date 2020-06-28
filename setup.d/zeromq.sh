#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://github.com/zeromq/libzmq/releases/download/v4.2.2/zeromq-4.2.2.tar.gz'
readonly DEST='/opt/zeromq'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkpkgconfig

