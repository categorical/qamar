#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.xz'
readonly DEST='/opt/lib/libvorbis'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"

linkpkgconfig


