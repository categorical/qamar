#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://github.com/georgmartius/vid.stab/archive/release-0.98b.tar.gz'
readonly DEST='/opt/lib/vidstab'

cachegetfile "$URI" 'regdest'
cmakeminimal "$regdest"
linkpkgconfig

