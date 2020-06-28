



function _run(){
    local -r b='/opt/apache2/bin/httpd'
    local -r ldplist='/Library/LaunchDaemons/apache2.plist'
    local -r f='/usr/local/etc/httpd/httpd.conf'
    case $@ in
        start) sudo "$b" -f "$f";;
        start\ -w) sudo launchctl load -w "$ldplist";;
        stop) sudo "$b" -f "$f" -k stop;;
        stop\ -w) sudo launchctl unload -w "$ldplist";;
        restart) sudo "$b" -f "$f" -k restart;;
        version) "$b" -V;;
        *) echo "usage: $CTL $ITEM {start [-w] | stop [-w] | restart | version}";;
    esac
}


