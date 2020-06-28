



function _run(){
    local -r b='/opt/php56/sbin/php-fpm'
    local -r ldplist='/Library/LaunchDaemons/php56fpm.plist'
    case $@ in
        start|start\ -w) sudo launchctl load -w "$ldplist";;
        stop|stop\ -w) sudo launchctl unload -w "$ldplist";;
        restart) sudo launchctl unload -w "$ldplist" \
            && sudo launchctl load -w "$ldplist";;
        version) "$b" -V;;
        *) echo "usage: $CTL $ITEM {start | stop | restart | version}";;
    esac
}


