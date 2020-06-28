#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='http://releases.ansible.com/ansible/ansible-2.3.0.0.tar.gz'

readonly DEST='/opt/ansible'
readonly PYTHON2="$DEST/./bin/python2"
readonly SSLDIR='/opt/openssl'

_install(){
    [ -f "$PYTHON2" ]||(sudo mkdir -p "$DEST" && cd "$DEST" && sudo virtualenv2 '.')
    readonly PYTHON2LIBDIR="$("$PYTHON2" -c 'from distutils.sysconfig import get_python_lib;print(get_python_lib())')"

    cachegetfile "$URI" 'regdest'
    (cd "$regdest" \
        && export LDFLAGS="-L$SSLDIR/lib" CFLAGS="-I$SSLDIR/include" \
        && "$PYTHON2" 'setup.py' build \
        && sudo -E "$PYTHON2" 'setup.py' install --prefix="$DEST" \
        && { 
        set -x
        find "$SRCDIR/`basename $regdest`" \
            -type d \
            -user root \
            -print0|xargs -0 sudo rm -R
        })

}

_config(){

    linkbin 'ansible'

    copyconfig 'ansible/hosts' 'ansible/hosts'
    copyuserconfig 'ansible/ansible.cfg' '.ansible.cfg'
    #(cd "$CONFIGDIR/ansible" \
    #    && curl -Lo 'ansible.cfg.sample' 'https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg') 
}

[ "$1" == '--config' ]||_install;_config








