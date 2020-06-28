#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='ftp://ftp.gnome.org/pub/gnome/sources/glib/2.53/glib-2.53.2.tar.xz'
readonly DEST='/opt/gnome/glib'

readonly GETTEXTDIR='/opt/gnu/gettext'
readonly PCREDIR='/opt/lib/pcre'

_install(){
    cachegetfile "$URI" 'regdest'

    pushd "$regdest" >/dev/null||exit 1
    CFLAGS="-I$GETTEXTDIR/include" \
    LDFLAGS="-L$GETTEXTDIR/lib" \
    ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean
    popd >/dev/null

}

_config(){
    :
    linkpkgconfig \
        'glib-2.0.pc' \
        'gobject-2.0.pc' \
        'gthread-2.0.pc' \
        'gmodule-no-export-2.0.pc' \
        'gio-2.0.pc' \
        'gmodule-2.0.pc' \
        'gio-unix-2.0.pc'

    linkbin 'glib-genmarshal'
    linkbin 'glib-mkenums'
    linkbin 'glib-compile-resources'
    linkbin 'gdbus-codegen'
    linkbin 'glib-compile-schemas'
    
}

case $1 in
    '--config')_config;;
    *)_install;_config;;
esac


