#!/bin/bash

. `dirname $0`/env.sh
import 'ftp' 'file'


readonly URI='ftp://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.xz'
readonly DEST='/opt/gnu/inetutils'


cachegetfile "$URI" 'regdest'

makeminimal "$regdest"



