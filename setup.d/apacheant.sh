#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://www-eu.apache.org/dist//ant/source/apache-ant-1.10.1-src.tar.xz'
readonly DEST='/opt/apacheant'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
mkdir -p bld \
&& ./build.sh -Ddist.dir=bld dist \
&& sudo mkdir -p "$DEST" \
&& (set -x;sudo cp -R bld/* "$DEST" && rm -R bld)
popd >/dev/null

linkbin 'ant'

