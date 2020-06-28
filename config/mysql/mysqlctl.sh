
function _run(){
    local -r b='/opt/mysql/bin/mysqld'
    local -r ldplist='/Library/LaunchDaemons/mysql.plist'
    local -r s='/opt/mysql/support-files/mysql.server'
    case $@ in
        start) sudo "$s" start;;
        start\ -w) sudo launchctl load -w "$ldplist";;
        stop) sudo "$s" stop;;
        stop\ -w) sudo launchctl unload -w "$ldplist";;
        reload) sudo "$s" reload;;
        restart) sudo "$s" restart;;
        status) sudo "$s" status;;
        version) "$b" -V;;
        *) echo "usage: $CTL $ITEM {start [-w] | stop [-w] | reload | restart | status | version}";;
    esac
}


