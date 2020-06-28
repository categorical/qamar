#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://gnu.mirror.constant.com/libtool/libtool-2.4.6.tar.xz'
readonly DEST='/opt/gnu/libtool'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkbin 'libtoolize'
linkbin 'libtool'

