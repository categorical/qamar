#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://github.com/ninja-build/ninja/archive/v1.7.2.tar.gz'

readonly DEST='/opt/ninja'
readonly PYTHON3='/opt/python36/bin/python3.6'

_install(){
    cachegetfile "$URI" 'regdest'
 
    pushd "$regdest" 1>/dev/null||exit 1 
        "$PYTHON3" configure.py --bootstrap \
            && (set -x;sudo mkdir -p "$DEST/bin" \
            && sudo cp './ninja' "$DEST/bin")
    popd 1>/dev/null

}

_config(){
    :
    linkbin 'ninja'
}

_remove()(
    set -x
    sudo rm -R /opt/ninja
    sudo rm /usr/local/bin/ninja

)

case $1 in
    '--config')_config;;
    '--remove')_remove;;
    *)_install;_config;;
esac






