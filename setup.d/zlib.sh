#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://zlib.net/zlib-1.2.11.tar.xz'
readonly DEST='/opt/lib/zlib'

cachegetfile "$URI" 'regdest'

makeminimal "$regdest"

linkpkgconfig

