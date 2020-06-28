#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='https://steamcdn-a.akamaihd.net/client/installer/steam.dmg'

_install(){
    _getfile(){
        http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
    }
    cacheget "$URI" '_getfile' 'regdest'

    file::installdmg "$regdest"
}

_remove()(
    :
    set -x
    rm -R '/Applications/Steam.app'
    rm -R "$HOME/Library/Application Support/Steam"
    rm "$HOME/Library/Saved Application State/com.valvesoftware.steam.savedState"    
    rm "$HOME/Library/LaunchAgents/com.valvesoftware.steamclean.plist"
    rm "$HOME/Library/Preferences/com.valvesoftware.steam.helper.plist"

)

case $1 in
    '--install')_install;;
    '--remove')_remove;;
    *);;
esac

