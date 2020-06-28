#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='https://download01.logi.com/web/ftp/pub/controldevices/unifying/unifying1.2.359_mac.zip'

_install(){
    _getfile(){
        http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
    }
    cacheget "$URI" '_getfile' 'regdest'

    _proliferate(){
        local f;f=$(find "$1" -type f -name '*.mpkg'|tail -n1)
        file::installpkg "$f"
    }
    
    file::withzip "$regdest" _proliferate
}

_remove()(
    set -x
    sudo rm -R '/Applications/Utilities/Logitech Unifying Software.app'
    sudo rm -R '/Library/Application Support/Logitech.localized'
    rm "$HOME/Library/Preferences/com.logitech.unifying.assistant.plist"
    rm "$HOME/Library/Preferences/com.Logitech.Updater.plist"
    rm -R "$HOME/Library/Caches/com.Logitech.Updater"

    sudo pkgutil --forget 'com.Logitech.Unifying Software.pkg'
    sudo pkgutil --forget 'com.Logitech.Updater.pkg'
)

case $1 in
    '--remove')_remove;;
    '--install')_install;;
    *);;
esac



