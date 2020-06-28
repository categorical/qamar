#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'


readonly URI='https://github.com/nghttp2/nghttp2/releases/download/v1.20.0/nghttp2-1.20.0.tar.bz2'
readonly DEST='/opt/lib/nghttp2'

cachegetfile "$URI" 'regdest'

makeminimal "$regdest"

linkpkgconfig


