#!/bin/bash

. `dirname $0`/env.sh
import 'ftp' 'file'


#readonly URI='https://ftp.gnu.org/gnu/automake/automake-1.15.tar.xz'
readonly URI='ftp://ftp.gnu.org/gnu/automake/automake-1.15.tar.xz'
readonly DEST='/opt/gnu/automake'


cachegetfile "$URI" 'regdest'
makeminimal "$regdest"

linkbin 'aclocal'
linkbin 'automake'

