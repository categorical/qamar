#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

# Required by `GIMP 2`.

readonly URI='ftp://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.31.tar.xz'
readonly DEST='/opt/gnome/gtk2'

readonly GETTEXTDIR='/opt/gnu/gettext'

_install(){
    cachegetfile "$URI" 'regdest'

    pushd "$regdest" >/dev/null||exit 1
    
    CFLAGS="-I$GETTEXTDIR/include" \
    LDFLAGS="-L$GETTEXTDIR/lib" \
    ./configure \
    --prefix="$DEST" \
    --with-gdktarget='quartz' \
    && make -j3 \
    && sudo make install \
    && make clean
    popd >/dev/null

    #--disable-x11-backend \
    #--enable-quartz-backend \
    #--disable-win32-backend \
    #--disable-vulkan \

}

_config(){
    :
    linkpkgconfig \
        'gtk+-2.0.pc' \
        'gdk-quartz-2.0.pc'


    linkbin 'gtk-update-icon-cache'

}

_remove()(
    :
    set -x
    sudo rm -R '/opt/gnome/gtk2'
    sudo rm '/usr/local/bin/gtk-update-icon-cache'
    sudo rm '/opt/lib/pkgconfig/gdk-quartz-2.0.pc'
    sudo rm '/opt/lib/pkgconfig/gtk+-2.0.pc'
    rm -R "$SRCDIR/gtk+-2.24.31"

)

case $1 in
    '--remove')_remove;;
    '--config')_config;;
    *)_install;_config;;
esac


