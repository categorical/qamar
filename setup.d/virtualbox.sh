#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'

readonly URI='http://download.virtualbox.org/virtualbox/5.1.22/VirtualBox-5.1.22-115126-OSX.dmg'

_install(){
    _getfile(){
        http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
    }
    cacheget "$URI" '_getfile' 'regdest'

    file::withdmg "$regdest" file::installpkg

}

_remove()(
    :
    set -x
    rm -R "$HOME/Library/Preferences/org.virtualbox.app.VirtualBox.plist"
    rm -R "$HOME/Library/Preferences/org.virtualbox.app.VirtualBoxVM.plist"    
    rm -R "$HOME/Library/Saved Application State/org.virtualbox.app.VirtualBox.savedState"    
    rm -R "$HOME/Library/Saved Application State/org.virtualbox.app.VirtualBoxVM.savedState"
    rm -R "$HOME/Library/VirtualBox"
    sudo rm "$HOME/Library/LaunchAgents/org.virtualbox.vboxwebsrv.plist"
    sudo rm -R '/Applications/VirtualBox.app'
    sudo rm -R '/Library/Application Support/VirtualBox'
    sudo rm '/Library/LaunchDaemons/org.virtualbox.startup.plist'
    rm -R "$HOME/VirtualBox VMs"

    sudo rm '/usr/local/bin/vboxwebsrv'
    sudo rm '/usr/local/bin/vbox-img'
    sudo rm '/usr/local/bin/VirtualBox'
    sudo rm '/usr/local/bin/VBoxVRDP'
    sudo rm '/usr/local/bin/VBoxManage'
    sudo rm '/usr/local/bin/VBoxHeadless'
    sudo rm '/usr/local/bin/VBoxDTrace'
    sudo rm '/usr/local/bin/VBoxBugReport'
    sudo rm '/usr/local/bin/VBoxBalloonCtrl'
    sudo rm '/usr/local/bin/VBoxAutostart'
       
 
    sudo pkgutil --forget 'org.virtualbox.pkg.vboxkexts'
    sudo pkgutil --forget 'org.virtualbox.pkg.virtualbox'
    sudo pkgutil --forget 'org.virtualbox.pkg.virtualboxcli'
        
    sudo rm -R '/Library/Python/2.6/site-packages/vboxapi'
    sudo rm -R '/Library/Python/2.7/site-packages/vboxapi'
    sudo rm '/Library/Python/2.6/site-packages/vboxapi-1.0-py2.6.egg-info'
    sudo rm '/Library/Python/2.7/site-packages/vboxapi-1.0-py2.7.egg-info'

    #kextstat -l|grep virtualbox
    sudo kextunload -m 'org.virtualbox.kext.VBoxUSB'
    sudo kextunload -m 'org.virtualbox.kext.VBoxNetFlt'
    sudo kextunload -m 'org.virtualbox.kext.VBoxNetAdp'

    sudo kextunload -m 'org.virtualbox.kext.VBoxDrv'

    #declare -r lsreg='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'
    #"$lsreg" -u '/Applications/VirtualBox.app'

)

case $1 in
    '--install')_install;;
    '--remove')_remove;;
    *);;
esac

