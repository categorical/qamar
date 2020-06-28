#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.xz'
readonly DEST='/opt/lib/libogg'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"

linkpkgconfig


