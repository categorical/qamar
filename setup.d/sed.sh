#!/bin/bash

. `dirname $0`/env.sh
import 'ftp' 'file'


readonly URI='https://ftp.gnu.org/gnu/sed/sed-4.4.tar.xz'
readonly DEST='/opt/gnu/sed'


cachegetfile "$URI" 'regdest'
makeminimal "$regdest"

linkbin 'sed'


