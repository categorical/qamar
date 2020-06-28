#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://vorboss.dl.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.5.tar.gz'
readonly DEST='/opt/lib/opencoreamr'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkpkgconfig


