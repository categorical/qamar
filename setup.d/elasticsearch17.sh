#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.6.tar.gz'
readonly DEST='/opt/elasticsearch17'
readonly DATADIR='/var/elasticsearch/data'


_install(){
    cachegetfile "$URI" 'regdest'
    pushd "$regdest" >/dev/null||exit 1
    (set -x;
    sudo mkdir -p "$DEST" \
    && sudo cp -R ./* "$DEST")
    popd >/dev/null
}

_config(){

    adduser '_elastic'
    sudo mkdir -p "`dirname "$DATADIR"`"
    for v in '/var/log/elasticsearch' "$DATADIR";do
        [ -d "$v" ]||{ (umask 022;sudo mkdir "$v") \
            && sudo chown '_elastic' "$v";}
    done

    copyconfig 'elasticsearch/n1/elasticsearch.yml' 'elasticsearch/n1/elasticsearch.yml'
    copyconfig 'elasticsearch/n1/logging.yml' 'elasticsearch/n1/logging.yml'
    #sudo mkdir '/usr/local/etc/elasticsearch/n1/scripts'

    if [ -d "$SUPERVISORPROGDIR" ];then
        copyconfig 'elasticsearch/n1/elasticsearchnode1.conf' "$SUPERVISORPROGDIR"
    fi
}

_remove()(
    :
    set -x
    sudo rm -R '/opt/elasticsearch17'
    #sudo rm -R '/var/elasticsearch'
    #sudo rm -R '/var/log/elasticsearch'
    #sudo rm -R '/usr/local/etc/elasticsearch'

)

case $1 in
    '--remove')_remove;;
    '--config')_config;;
    *)_install;_config;;
esac


