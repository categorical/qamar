#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='https://artifacts.elastic.co/downloads/kibana/kibana-6.0.0-alpha1-darwin-x86_64.tar.gz'
readonly DEST='/opt/kibana'

_install(){
    cachegetfile "$URI" 'regdest'
    pushd "$regdest" >/dev/null||exit 1
    (set -x;
    sudo mkdir -p "$DEST" \
    && sudo rsync -a ./ "$DEST" --exclude '/node')
    popd >/dev/null
 
    f="$DEST/optimize/.babelcache.json"
    [ ! -f "$f" ]||sudo chmod o+w "$f"
}

_config(){

    adduser '_elastic'
    copyconfig 'kibana/kibana.yml' 'kibana/kibana.yml'

    if [ -d "$SUPERVISORPROGDIR" ];then
        copyconfig 'kibana/kibana.conf' "$SUPERVISORPROGDIR"
    fi

    setvhost 'kibana' 'http://127.0.0.1:55601'
}

_remove()(
    :
    set -x
    sudo rm -R '/opt/kibana'
    sudo rm -R '/usr/local/etc/kibana'

)

case $1 in
    '--remove')_remove;;
    '--config')_config;;
    *)_install;_config;;
esac


