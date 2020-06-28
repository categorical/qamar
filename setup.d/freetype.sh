#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='http://download.savannah.gnu.org/releases/freetype/freetype-2.7.1.tar.bz2'
readonly DEST='/opt/lib/freetype'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"

linkpkgconfig


