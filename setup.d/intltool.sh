#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz'
readonly DEST='/opt/lib/intltool'

cachegetfile "$URI" 'regdest'

makeminimal "$regdest"

linkbin 'intltool-update'
linkbin 'intltool-extract'
linkbin 'intltool-merge'

