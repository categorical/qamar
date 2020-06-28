#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://vorboss.dl.sourceforge.net/project/modplug-xmms/libmodplug/0.8.8.5/libmodplug-0.8.8.5.tar.gz'
readonly DEST='/opt/lib/libmodplug'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"

linkpkgconfig


