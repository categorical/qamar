#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://vorboss.dl.sourceforge.net/project/opencore-amr/vo-amrwbenc/vo-amrwbenc-0.1.3.tar.gz'
readonly DEST='/opt/lib/voamrwbenc'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkpkgconfig

