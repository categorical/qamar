#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='http://downloads.us.xiph.org/releases/speex/speex-1.2.0.tar.gz'
readonly DEST='/opt/lib/speex'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkpkgconfig

