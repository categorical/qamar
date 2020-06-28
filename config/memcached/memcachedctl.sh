

function _run(){
    local -r b='/opt/memcached/bin/memcached'
    local -r ldplist='/Library/LaunchDaemons/memcached.plist'
    case $@ in
        start|start\ -w) sudo launchctl load -w "$ldplist";;
        stop|stop\ -w) sudo launchctl unload -w "$ldplist";;
        version) "$b" -V;;
        *) echo "usage: $CTL $ITEM {start | stop | version}";;
    esac

}


