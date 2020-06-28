#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://s3.amazonaws.com/json-c_releases/releases/json-c-0.12.1.tar.gz'
readonly DEST='/opt/lib/jsonc'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"
linkpkgconfig

