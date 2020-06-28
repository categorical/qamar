#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://vorboss.dl.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2'
readonly DEST='/opt/p7zip'

cachegetfile "$URI" 'regdest'

pushd "$regdest/CPP/7zip" >/dev/null||exit 1
(mkdir -p bld \
    && cd bld \
    && cmake '../CMAKE' \
    && make -j3 \
    && (set -x;sudo mkdir -p "$DEST/bin" \
    && sudo cp './bin/7za' "$DEST/bin") \
    && make clean)
rm -Rf bld
popd >/dev/null

linkbin '7za'

