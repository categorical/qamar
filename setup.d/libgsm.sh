#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://libgsm.sourcearchive.com/downloads/1.0.13/libgsm_1.0.13.orig.tar.gz'
readonly DEST='/opt/lib/libgsm'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
sed -i "s/^\(INSTALL_ROOT\).*$/\1=$(strings::escapesed "$DEST")/" ./Makefile
make \
&& sudo mkdir -p "$DEST/bin" "$DEST/lib" "$DEST/inc" "$DEST/man/man1" "$DEST/man/man3" \
&& sudo make install

popd >/dev/null

#sudo mkdir -p "$DEST/lib/pkgconfig" \
#&& cat << EOF|sudo tee >/dev/null "$DEST/lib/pkgconfig/libgsm.pc"
#prefix=${DEST}
#exec_prefix=\${prefix}
#libdir=\${exec_prefix}/lib
#includedir=\${prefix}/inc
#
#Name: libgsm
#Description:
#Version: 1.0.13
#Libs: -L\${libdir} -lgsm
#Libs.private:
#Cflags: -I\${includedir}
#EOF
#
#linkpkgconfig

