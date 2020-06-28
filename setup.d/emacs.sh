#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://ftp.gnu.org/gnu/emacs/emacs-25.2.tar.xz'
readonly DEST='/opt/emacs'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
--disable-ns-self-contained \
--without-ns \
&& make -j2 \
&& sudo make install \
&& make clean\
&& make distclean
popd >/dev/null 

linkbin 'emacs'


