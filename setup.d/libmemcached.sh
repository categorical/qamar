#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'strings'

readonly URI='https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz'
readonly DEST='/opt/lib/libmemcached'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1

p="$(cat <<'EOF'
#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
EOF
)"
l='#include "libmemcached/byteorder.h"'
f='./libmemcached/byteorder.cc'
tr -d '\n' < "$f"|if ! grep "$(echo "$p"|tr -d '\n')";then
    sed -i "0,/$(strings::escapebresed "$l")/s//&\n$(strings::escapesed "$p")/" "$f"
fi

p='if (opt_servers == NULL)'
l='if (opt_servers == false)'
f='./clients/memflush.cc'
sed -i "s/$(strings::escapebresed "$l")/$(strings::escapesed "$p")/" "$f"

./configure \
--prefix="$DEST" \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null

linkpkgconfig


