#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://vorboss.dl.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz'
readonly DEST='/opt/lib/libuuid'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkpkgconfig

