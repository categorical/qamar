

function _run(){
    local -r b='/opt/rsyslog/sbin/rsyslogd'
    local -r ldplist='/Library/LaunchDaemons/rsyslogd.plist'
    local -r f='/usr/local/etc/rsyslog/rsyslog.conf'
    local -r i='/var/run/rsyslog/rsyslogd.pid'

    case $@ in
        start|start\ -w)
            sudo launchctl load -w "$ldplist";;
        stop|stop\ -w)
            sudo launchctl unload -w "$ldplist"
            [ ! -f "$i" ]||sudo kill `cat "$i"`
            ;;
        restart)
            sudo launchctl unload -w "$ldplist"
            sudo launchctl load -w "$ldplist"
            ;;
        debug) 
            (export \
                RSYSLOG_DEBUG='debug nostdout' \
                RSYSLOG_DEBUGLOG='/var/log/rsyslog/debug.log'
            sudo -E "$b" -i "$i" -f "$f")
            ;;
        version) "$b" -v;;
        *) echo "usage: $CTL $ITEM {start | stop | restart | debug | version}";;
    esac
}


