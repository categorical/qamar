#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='ftp://ftp.gnome.org/pub/gnome/sources/gtk-mac-integration/2.0/gtk-mac-integration-2.0.8.tar.xz'
readonly DEST='/opt/gnome/gtkmacintegration'

_install(){
    cachegetfile "$URI" 'regdest'

    (cd "$regdest" \
        && ./configure \
        --prefix="$DEST" \
        && make -j2 \
        && sudo make install \
        && make clean\
        && make distclean)

}

_config(){
    :
    linkpkgconfig 'gtk-mac-integration-gtk2.pc'
    
}

_remove()(
    :
    set -x
    sudo rm -R '/opt/gnome/gtkmacintegration'
    #sudo rm '/opt/lib/pkgconfig/gtk-mac-integration.pc'
    sudo rm '/opt/lib/pkgconfig/gtk-mac-integration-gtk2.pc'
    rm -R "$SRCDIR/gtk-mac-integration-2.0.8"

)


case $1 in
    '--remove')_remove;;
    '--config')_config;;
    *)_install;_config;;
esac




