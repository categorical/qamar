#!/bin/bash

. `dirname $0`/env.sh
import 'ftp' 'file'


readonly URI='ftp://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz'
readonly DEST='/opt/gnu/autoconf'


cachegetfile "$URI" 'regdest'
makeminimal "$regdest"

linkbin 'autoconf'
linkbin 'autoheader'
linkbin 'autoreconf'

