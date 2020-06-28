


function _run(){
    local -r b='/opt/redis/bin/redis-server'
    local -r ldplist='/Library/LaunchDaemons/redis.plist'
    case $@ in
        start|start\ -w) sudo launchctl load -w "$ldplist";;
        stop|stop\ -w) sudo launchctl unload -w "$ldplist";;
        version) "$b" --version;;
        *) echo "usage: $CTL $ITEM {start | stop | version}";;
    esac

}


