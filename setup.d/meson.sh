#!/bin/bash

. `dirname $0`/env.sh
import 'out'

# Not installed.
# `libepoxy` prefers this item, but `Make` works fine.
# This item failed to build `libepoxy` on its first (and only) run:
# `ld: malformed 32-bit x.y.z version number: =1`
# 

readonly URI='https://github.com/mesonbuild/meson/releases/download/0.40.1/meson-0.40.1.tar.gz'

readonly DEST='/opt/meson'
readonly PYTHON3="$DEST/./bin/python3"

_install(){
    [ -f "$PYTHON3" ]||(sudo mkdir -p "$DEST" && cd "$DEST" && sudo virtualenv3 '.')

    cachegetfile "$URI" 'regdest'
   
    pushd "$regdest" 1>/dev/null||exit 1 
        "$PYTHON3" 'setup.py' build \
        && sudo "$PYTHON3" 'setup.py' install --prefix="$DEST" \
        && (set -x;sudo rm -R "$SRCDIR/meson-0.40.1")
    popd 1>/dev/null

}

_config(){
    :
    linkbin 'meson'
}

_remove()(
    set -x
    sudo rm -R /opt/meson
    sudo rm /usr/local/bin/meson

)

case $1 in
    '--config')_config;;
    '--remove')_remove;;
    *)_install;_config;;
esac






