#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file' 'strings'

readonly URI='http://download.jetbrains.com/webide/PhpStorm-8.0.4.dmg'


_install(){
    _getfile(){
        http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
    }
    cacheget "$URI" '_getfile' 'regdest'
    file::installdmg "$regdest"
}

_config(){
    :
    setenv 'PHPSTORM_JDK' '$JAVA_HOME'
    
    # Sets environment variables for GUI invocation as well.
    #launchctl setenv 'PHPSTORM_JDK' "$JAVA_HOME"
    #launchctl getenv 'PHPSTORM_JDK'
    declare -r item='/Applications/PhpStorm.app'
        if [ -d "$item" ];then
        
        local f="$item/Contents/Info.plist"
        local l='<dict>';lescaped="$(strings::escapebresed "$l")"
        local p="$(cat <<-EOF
        <key>LSEnvironment</key>
        <dict>
            <key>PHPSTORM_JDK</key>
            <string>$JAVA_HOME</string>
        </dict>
		EOF
        )";p="${p//[[:space:]]}";pescaped="$(strings::escapesed "$p")"
        fgrep "$p" "$f" >/dev/null \
            ||sed -i "0,/$lescaped/!b;/$lescaped/!b;a$pescaped" "$f"

        # Ensures changes to Info.plist are reflected in Launch Services' database.
        #declare -r lsreg='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'
        #"$lsreg" -v -f "$item"
        touch "$item"
    fi
}

_remove()(
    set -x
    rm -R '/Applications/PhpStorm.app'
    rm -R "$HOME/Library/Preferences/WebIde80"
    rm -R "$HOME/Library/Logs/WebIde80"
    rm -R "$HOME/Library/Caches/WebIde80"
    sudo rm '/usr/local/bin/pstorm'
    :
)

case $1 in
    '--remove')_remove;;
    '--config')_config;;
    *)_install;_config;;
esac

