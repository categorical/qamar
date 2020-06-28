


function _run(){
    local -r b='/opt/nginx/sbin/nginx'
    local -r ldplist='/Library/LaunchDaemons/nginx.plist'
    case $@ in
        start) sudo "$b";;
        start\ -w) sudo launchctl load -w "$ldplist";;
        stop) sudo "$b" -s quit;;
        stop\ -w) sudo launchctl unload -w "$ldplist";;
        reload) sudo "$b" -s reload;;
        restart) sudo "$b" -s quit && sudo "$b";;
        version) "$b" -V;;
        *) echo "usage: $CTL $ITEM {start [-w] | stop [-w] | reload | restart | version}";;
    esac
}


