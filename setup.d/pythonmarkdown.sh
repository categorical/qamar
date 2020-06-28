#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://pypi.python.org/packages/source/M/Markdown/Markdown-2.6.6.tar.gz'

readonly DEST='/opt/pythonmarkdown'
readonly PYTHON2="$DEST/./bin/python2"

_install(){
    
    [ -f "$PYTHON2" ]||(sudo mkdir -p "$DEST" && cd "$DEST" && sudo virtualenv2 '.')
    cachegetfile "$URI" 'regdest'
    (cd "$regdest" \
        && "$PYTHON2" 'setup.py' build \
        && sudo "$PYTHON2" 'setup.py' install --prefix="$DEST")
}

_config(){
    :
    linkbin 'markdown_py' 'markdown'
}

_remove()(
    set -x
    sudo rm -R /opt/pythonmarkdown
    rm -R "$SRCDIR/Markdown-2.6.6"
)

case $1 in
    '--config')_config;;
    '--remove')_remove;;
    *)_install;_config;;
esac






