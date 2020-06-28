#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='http://artfiles.org/videolan.org/vlc/2.2.5.1/macosx/vlc-2.2.5.1.dmg'

_install(){
    _getfile(){
        http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
    }
    cacheget "$URI" '_getfile' 'regdest'

    file::installdmg "$regdest"


}


_config(){
    :
    sudo rm '/usr/local/bin/vlc'
    copyconfig 'vlc/vlcdelegate' '/usr/local/bin/vlc'

    sudo rm '/usr/local/bin/cvlc'
    copyconfig 'vlc/cvlcdelegate' '/usr/local/bin/cvlc'

}


case $1 in
    '--config')_config;;
    *)_install;_config;;
esac


