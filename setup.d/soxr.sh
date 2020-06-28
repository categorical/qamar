#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://vorboss.dl.sourceforge.net/project/soxr/soxr-0.1.2-Source.tar.xz'
readonly DEST='/opt/lib/soxr'

cachegetfile "$URI" 'regdest'
cmakeminimal "$regdest"
linkpkgconfig

