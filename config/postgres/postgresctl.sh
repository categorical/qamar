


function _run(){
    local -r b='/opt/postgres/bin/postgres'
    local -r ldplist='/Library/LaunchDaemons/postgres.plist'
    case $@ in
        start|start\ -w) sudo launchctl load -w "$ldplist";;
        stop|stop\ -w) sudo launchctl unload -w "$ldplist";;
        restart)
            sudo launchctl unload "$ldplist"
            sudo launchctl load -w "$ldplist"
            ;;
        version) "$b" -V;;
        *) echo "usage: $CTL $ITEM {start | stop | restart | version}";;
    esac
}


