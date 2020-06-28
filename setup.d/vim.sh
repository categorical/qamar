#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://github.com/vim/vim/archive/v8.0.0563.tar.gz'
readonly DEST='/opt/vim'

cachegetfile "$URI" 'regdest'

readonly PYTHONDIR='/opt/python27'
pushd "$regdest" >/dev/null
./configure \
--prefix="$DEST" \
--with-features=huge \
--enable-multibyte \
--enable-pythoninterp \
--with-python-config-dir="$PYTHONDIR/lib/python2.7/config" \
--enable-perlinterp \
--enable-luainterp \
&& make -j2 \
&& sudo make install \
&& make clean \
&& make distclean
popd >/dev/null

linkbin 'vim' 'vi'
copyuserconfig 'vim/vimrc' '.vimrc'

