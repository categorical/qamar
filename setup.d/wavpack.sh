#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='http://www.wavpack.com/wavpack-5.1.0.tar.bz2'
readonly DEST='/opt/lib/wavpack'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"

linkpkgconfig

