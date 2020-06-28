#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly MELD3URI='https://github.com/Supervisor/meld3/archive/1.0.2.tar.gz'
readonly ELEMENTTREEURI='http://effbot.org/media/downloads/elementtree-1.2.6-20050316.tar.gz'
readonly URI='https://github.com/Supervisor/supervisor/archive/3.3.1.tar.gz'

readonly DEST='/opt/supervisor'
readonly PYTHON2="$DEST/./bin/python2"


_install(){
    [ -f "$PYTHON2" ]||(sudo mkdir -p "$DEST" && cd "$DEST" && sudo virtualenv2 '.')
    readonly PYTHON2LIBDIR="$("$PYTHON2" -c 'from distutils.sysconfig import get_python_lib;print(get_python_lib())')"

    for v in "$MELD3URI" "$ELEMENTTREEURI" "$URI";do
        cachegetfile "$v" 'regdest'
        (cd "$regdest" \
            && "$PYTHON2" 'setup.py' build \
            && sudo "$PYTHON2" 'setup.py' install --prefix="$DEST" \
            && {
            set -x
            sudo rm -R "$SRCDIR/`basename $regdest`"
            })
    done
}

_config(){
    linkbin 'supervisorctl'

    #adduser '_supervisor'
    # Supervisord must be run by the root user,
    # otherwise, it cannot spawn child processes as another non root user.
    for v in '/var/log/supervisor' '/var/run/supervisor';do
        [ -d "$v" ]||(umask 022;sudo mkdir "$v")
    done

    #"$DEST/bin/echo_supervisord_conf" > "$CONFIGDIR/supervisor/supervisord.conf.sample"
    copyconfig 'supervisor/supervisord.conf' 'supervisor/supervisord.conf'
    copyconfig 'supervisor/conf.d/prog0.conf' 'supervisor/conf.d/prog0.conf'
    
    copyconfig 'supervisor/supervisord.plist' '/Library/LaunchDaemons' \
        && sudo chown root:wheel '/Library/LaunchDaemons/supervisord.plist'
    copyuserconfig 'supervisor/supervisordctl.sh' '.bashctl.d'

    [ -f "$DEST/bin/supervisord.rename" ] \
        || sudo mv "$DEST/bin/supervisord" "$DEST/bin/supervisord.rename" \
        && copyconfig 'supervisor/supervisord.delegate' "$DEST/bin/supervisord"

    #sudo rm -R /var/log/supervisor /var/run/supervisor
}

[ "$1" == '--config' ]||_install;_config




#sudo pip2 install supervisor




