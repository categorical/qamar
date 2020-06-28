#!/bin/bash

. `dirname $0`/env.sh
import 'out'
readonly URI='https://ftp.gnu.org/gnu/gdb/gdb-7.12.1.tar.xz'
readonly DEST='/opt/gnu/gdb'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkbin 'gdb'

