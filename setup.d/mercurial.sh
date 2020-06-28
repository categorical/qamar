#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://www.mercurial-scm.org/release/mercurial-4.2.1.tar.gz'

readonly DEST='/opt/mercurial'
readonly PYTHON2="$DEST/./bin/python2"
readonly SSLDIR='/opt/openssl'

_install(){
    [ -f "$PYTHON2" ]||(sudo mkdir -p "$DEST" && cd "$DEST" && sudo virtualenv2 '.')
    readonly PYTHON2LIBDIR="$("$PYTHON2" -c 'from distutils.sysconfig import get_python_lib;print(get_python_lib())')"

    cachegetfile "$URI" 'regdest'
    (cd "$regdest" \
        && "$PYTHON2" 'setup.py' build \
        && sudo "$PYTHON2" 'setup.py' install --prefix="$DEST")

}

_config(){
    linkbin 'hg'
    copyuserconfig 'mercurial/hgrc' '.hgrc'
}

[ "$1" == '--config' ]||_install;_config








