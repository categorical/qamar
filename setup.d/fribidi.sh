#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://fribidi.org/download/fribidi-0.19.7.tar.bz2'
readonly DEST='/opt/lib/fribidi'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkpkgconfig

