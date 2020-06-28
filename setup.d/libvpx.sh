#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.6.1.tar.bz2'
readonly DEST='/opt/lib/libvpx'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"

linkpkgconfig


