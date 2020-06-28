#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://vorboss.dl.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz'
readonly DEST='/opt/lib/libmp3lame'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"



