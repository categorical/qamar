#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://ijg.org/files/jpegsrc.v9b.tar.gz'
readonly DEST='/opt/lib/libjpeg'

cachegetfile "$URI" 'regdest'

makeminimal "$regdest"

