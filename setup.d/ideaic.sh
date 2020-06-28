#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file' 'strings'


readonly URI='https://download.jetbrains.com/idea/ideaIC-2017.1.2.dmg'

_install(){
    _getfile(){
        http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
    }
    cacheget "$URI" '_getfile' 'regdest'
    file::installdmg "$regdest"
}

_config(){
    :
    setenv 'IDEA_JDK' '$JAVA_HOME'

    declare -r item='/Applications/IntelliJ IDEA CE.app'
    if [ -d "$item" ];then
        local f="$item/Contents/Info.plist"
        local l='<dict>';lescaped="$(strings::escapebresed "$l")"
        local p="$(cat <<-EOF
        <key>LSEnvironment</key>
        <dict>
            <key>IDEA_JDK</key>
            <string>$JAVA_HOME</string>
        </dict>
		EOF
        )";p="${p//[[:space:]]}";pescaped="$(strings::escapesed "$p")"
        fgrep "$p" "$f" >/dev/null \
            ||sed -i "0,/$lescaped/!b;/$lescaped/!b;a$pescaped" "$f"

        touch "$item"
        (set -x;rm -R "$item/Contents/jdk")
    fi
    
}

_remove()(
    :
    set -x
    rm -R '/Applications/IntelliJ IDEA CE.app'
)

case $1 in
    '--remove')_remove;;
    '--config')_config;;
    *)_install;_config;;
esac


