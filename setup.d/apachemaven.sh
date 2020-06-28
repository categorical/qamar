#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='http://www-eu.apache.org/dist/maven/maven-3/3.5.0/source/apache-maven-3.5.0-src.tar.gz'
readonly DEST='/opt/apachemaven'

readonly M305URI='http://ftp.fau.de/apache//maven/maven-3/3.0.5/source/apache-maven-3.0.5-src.tar.gz'
readonly ANT='/opt/apacheant/bin/ant'

_bootstrap(){
    :
    cachegetfile "$M305URI" 'm305dest'
    pushd "$m305dest" >/dev/null||exit 1
    M2_HOME="$bootstrapdir" "$ANT" -Dmaven.repo.local="$HOME/Library/Caches/maven"
    popd >/dev/null
}

_install(){
    cachegetfile "$URI" 'regdest'
    pushd "$regdest" >/dev/null||exit 1
    local -r bootstrapdir="$(file::abspath './bootstrap')"
    _bootstrap
    
    
    local -r bootstrapmvn="$bootstrapdir/bin/mvn"
    [ -x "$bootstrapmvn" ] \
        && "$bootstrapmvn" \
            -Dmaven.repo.local="$HOME/Library/Caches/maven" \
            -DdistributionTargetDir="$(file::abspath "./bld")" \
            clean package
    
    [ "$?" == 0 ]||exit 1

    (set -x;sudo mkdir -p "$DEST" \
        && sudo cp -R bld/* "$DEST" \
        && rm -R bld)

    popd >/dev/null

}
_config(){
    linkbin 'mvn'
    copyuserconfig 'maven/settings.xml' '.m2/settings.xml'
}

case $1 in
    '--config')_config;;
    *)_install;_config;;
esac
