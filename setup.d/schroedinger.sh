#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'strings'


readonly URI='https://launchpad.net/schroedinger/trunk/1.0.11/+download/schroedinger-1.0.11.tar.gz'
readonly DEST='/opt/lib/schroedinger'


readonly ORCDIR='/opt/lib/orc'

_install(){
    cachegetfile "$URI" 'regdest'
    pushd "$regdest" >/dev/null||exit 1

    f='./schroedinger/Makefile.in'
    l="-export-symbols-regex '^schro_'";
    p="-export-symbols-regex '^_?(schro|orc)_'"
    sed -i "s/$(strings::escapebresed "$l")/$(strings::escapesed "$p")/" "$f"    

    #ORC_CFLAGS="-I$ORCDIR/include/orc-0.4" \
    #ORC_LIBS="-L$ORCDIR/lib -lorc-0.4" \
    ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean \
    && make distclean
    popd >/dev/null
}
_install

linkpkgconfig



