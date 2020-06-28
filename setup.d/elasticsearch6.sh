#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.0.0-alpha1.tar.gz'
readonly DEST='/opt/elasticsearch6'
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

    for i in '0' '2';do
        copyconfig "elasticsearch/n$i/elasticsearch.yml" "elasticsearch/n$i/elasticsearch.yml"
        copyconfig "elasticsearch/n$i/log4j2.properties" "elasticsearch/n$i/log4j2.properties"
        copyconfig "elasticsearch/n$i/jvm.options" "elasticsearch/n$i/jvm.options"
        
        scriptdir="/usr/local/etc/elasticsearch/n$i/scripts"
        [ -d "$scriptdir" ] || sudo mkdir "$scriptdir"

        if [ -d "$SUPERVISORPROGDIR" ];then
            copyconfig "elasticsearch/n$i/elasticsearchnode$i.conf" "$SUPERVISORPROGDIR"
        fi
    done
}

_remove()(
    :
    set -x
    sudo rm -R '/opt/elasticsearch6'
    sudo rm -R '/var/elasticsearch'
    sudo rm -R '/var/log/elasticsearch'
    sudo rm -R '/usr/local/etc/elasticsearch'

)

case $1 in
    '--remove')_remove;;
    '--config')_config;;
    *)_install;_config;;
esac


