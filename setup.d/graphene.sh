#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://github.com/ebassi/graphene/archive/1.6.0.tar.gz'
readonly DEST='/opt/lib/graphene'

readonly PKGCONFIGDIR='/opt/pkgconfig'

cachegetfile "$URI" 'regdest'

(cd "$regdest" \
    && libtoolize \
    && touch 'gtk-doc.make' \
    && autoreconf -ivf -I "$PKGCONFIGDIR/share/aclocal" \
    && ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean\
    && make distclean)

linkpkgconfig 'graphene-gobject-1.0.pc'

