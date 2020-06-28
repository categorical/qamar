#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://sourceforge.net/projects/ex-vi/files/ex-vi/050325/ex-050325.tar.bz2'
readonly DEST='/opt/vi'

cachegetfile "$URI" 'regdest'

# Not installed.


