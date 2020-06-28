#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://nmap.org/dist/nmap-7.40.tar.bz2'
readonly DEST='/opt/nmap'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkbin 'nmap'


