#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='https://download.brother.com/welcome/dlf102952/Brother_PrinterDrivers_MonochromeLaser_1_2_0.dmg'

_install(){
    _getfile(){
        http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
    }
    cacheget "$URI" '_getfile' 'regdest'

    file::withdmg "$regdest" file::installpkg
}

_config(){
    :
}
_remove()(
    :
    set -x
    sudo rm -R '/Library/Printers/Brother'
    find '/Library/Printers/PPDs' -name 'Brother*' -print0|xargs -0 sudo rm
    sudo pkgutil --forget 'com.Brother.Brotherdriver.Brother_PrinterDrivers_MonochromeLaser'
    
    #local f='/Library/Printers/InstalledPrinters.plist';if [ -f "$f" ];then
    #   sudo sed -i '/<string>MANUFACTURER:Brother;MODEL:HL-2560DN<\/string>/d' "$f"
    #   sudo sed -i '/<string>Brother<\/string>/d' "$f"
    #fi
)


case $1 in
    '--remove')_remove;;
    *)_install;_config;;
esac


