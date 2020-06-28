#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file' 'strings'

readonly URI='http://artfiles.org/eclipse.org/technology/epp/downloads/release/neon/3/eclipse-committers-neon-3-macosx-cocoa-x86_64.tar.gz'

_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}

_install(){
    cacheget "$URI" '_getfile' 'regdest'
    file::installzip "$regdest"
}

_config(){
    :
    declare -r item='/Applications/Eclipse.app'
    if [ -d "$item" ];then
        local f="$item/Contents/Info.plist"
        local l0='<key>Eclipse</key>' l1='<array>'
        local p="<string>-vm</string><string>$JAVA_HOME/Contents/Home/bin/java</string>"
        local pescaped=$(strings::escapesed "$p")
        l0=$(strings::escapebresed "$l0")
        l1=$(strings::escapebresed "$l1")
        fgrep "$p" "$f" >/dev/null \
            ||sed -i "/$l0/,/$l1/!b;/$l1/a$pescaped" "$f"

        touch "$item"

        f="$item/Contents/Eclipse/eclipse.ini"
        
    fi
}

_remove()(
    :
    set -x
    rm -R '/Applications/Eclipse.app'
    rm -R "$HOME/.eclipse"
    rm -R "$HOME/.p2"
)


case $1 in
    '--config')_config;;
    '--remove')_remove;;
    *)_install;_config;;
esac

