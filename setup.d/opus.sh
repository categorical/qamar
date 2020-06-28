#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://downloads.xiph.org/releases/opus/opus-1.1.4.tar.gz'
readonly DEST='/opt/lib/opus'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkpkgconfig


