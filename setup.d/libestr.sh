#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://libestr.adiscon.com/files/download/libestr-0.1.10.tar.gz'
readonly DEST='/opt/lib/libestr'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkpkgconfig

