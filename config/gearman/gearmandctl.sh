

function _run(){
    local -r b='/opt/gearman/sbin/gearmand'
    local -r ldplist='/Library/LaunchDaemons/gearmand.plist'
    case $@ in
        start|start\ -w) sudo launchctl load -w "$ldplist";;
        stop|stop\ -w) sudo launchctl unload -w "$ldplist";;
        version) "$b" -V;;
        *) echo "usage: $CTL $ITEM {start | stop | version}";;
    esac

}


