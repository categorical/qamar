#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.1.tar.bz2'
readonly DEST='/opt/lib/fontconfig'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkpkgconfig

