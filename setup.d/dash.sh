#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='https://london.kapeli.com/downloads/v4/Dash.zip'

_install(){
    _getfile(){
        http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
    }
    cacheget "$URI" '_getfile' 'regdest'

    file::installzip "$regdest"
}

_remove()(
    :
    set -x
    rm -R '/Applications/Dash.app'
    rm -R "$HOME/Library/Application Support/Dash"
    rm -R "$HOME/Library/Application Support/com.kapeli.dashdoc"
    rm "$HOME/Library/Preferences/com.kapeli.dashdoc.plist"
    rm -R "$HOME/Library/Logs/Dash"
    rm -R "$HOME/Library/Caches/com.kapeli.dashdoc"
    rm "$HOME/Library/Cookies/com.kapeli.dashdoc.binarycookies"
    rm -R "$HOME/Library/Caches/com.plausiblelabs.crashreporter.data/com.kapeli.dashdoc"

)

case $1 in
    '--remove')_remove;;
    *)_install;;
esac



