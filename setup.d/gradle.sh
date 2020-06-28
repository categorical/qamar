#!/bin/bash

. `dirname $0`/env.sh
import 'out'

#readonly URI='https://services.gradle.org/distributions/gradle-3.5-all.zip'
readonly URI='https://github.com/gradle/gradle/archive/v3.5.0.tar.gz'
readonly DEST='/opt/gradle'

_install(){
    cachegetfile "$URI" 'regdest'

    pushd "$regdest" >/dev/null||exit 1
    GRADLE_USER_HOME="$HOME/Library/Caches/gradle" \
    ./gradlew installAll \
        -Pgradle_installPath=bld \
        #-g "$HOME/Library/Caches/gradle" 
    [ "$?" == 0 ]||exit 1

    (set -x;sudo mkdir -p "$DEST" \
        && sudo cp -R bld/* "$DEST" \
        && rm -R bld)

    popd >/dev/null
}

_config(){
    :
    linkbin 'gradle'
    setenv 'GRADLE_USER_HOME' '$HOME/Library/Caches/gradle'
}

[ "$1" == '--config' ]||_install;_config








