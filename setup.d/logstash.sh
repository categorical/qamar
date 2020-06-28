#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='https://artifacts.elastic.co/downloads/logstash/logstash-6.0.0-alpha1.tar.gz'
readonly DEST='/opt/logstash'

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
    datadir='/var/logstash/data'
    sudo mkdir -p "`dirname "$datadir"`"
    for v in '/var/log/logstash' "$datadir";do
        [ -d "$v" ]||{ (umask 022;sudo mkdir "$v") \
            && sudo chown '_elastic' "$v";}
    done

    copyconfig 'logstash/logstash.yml' 'logstash/logstash.yml'
    copyconfig 'logstash/log4j2.properties' 'logstash/log4j2.properties'
    copyconfig 'logstash/jvm.options' 'logstash/jvm.options'
    copyconfig 'logstash/conf.d/foo.conf' 'logstash/conf.d/foo.conf'

    if [ -d "$SUPERVISORPROGDIR" ];then
        copyconfig 'logstash/logstash.conf' "$SUPERVISORPROGDIR"
    fi
}

_remove()(
    :
    set -x
    sudo rm -R '/opt/logstash'
    sudo rm -R '/var/logstash'
    sudo rm -R '/var/log/logstash'
    sudo rm -R '/usr/local/etc/logstash'

)

case $1 in
    '--remove')_remove;;
    '--config')_config;;
    *)_install;_config;;
esac


