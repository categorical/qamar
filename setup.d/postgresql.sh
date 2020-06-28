#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='https://ftp.postgresql.org/pub/source/v9.6.2/postgresql-9.6.2.tar.bz2'
readonly DEST='/opt/postgres'

_install(){
    cachegetfile "$URI" 'regdest'

    pushd "$regdest" >/dev/null||exit 1
    ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean \
    && make distclean
    popd >/dev/null
}

_config(){
    
    # Config
    linkbin "$DEST/bin/psql"
    readonly DATADIR='/var/postgres/data' LOGDIR='/var/log/postgres'
    sudo mkdir -p "`dirname "$DATADIR"`"
    for v in "$DATADIR" "$LOGDIR";do
        [ -d "$v" ]||{ (umask 077;sudo mkdir "$v") \
            && sudo chown _postgres "$v";}
    done

    [ "$(sudo ls -A "$DATADIR")" ] \
        ||sudo -u _postgres "$DEST/bin/initdb" -D "$DATADIR" -A 'trust' 1>/dev/null

    copyconfig 'postgres/postgresql.conf' 'postgres/postgresql.conf'

    for v in 'pg_hba.conf' 'pg_ident.conf';do
        [ -f "/usr/local/etc/postgres/$v" ] \
            ||sudo cp -p "$DATADIR/$v" "/usr/local/etc/postgres/$v"
            #||sudo cp "$DEST/share/${v}.sample" "/usr/local/etc/postgres/$v"
    done

    copyconfig 'postgres/postgres.plist' '/Library/LaunchDaemons' \
        && sudo chown root:wheel '/Library/LaunchDaemons/postgres.plist'

    copyuserconfig 'postgres/postgresctl.sh' '.bashctl.d'

    # Database
    sudo killall postgres 2>/dev/null
    sudo -u _postgres "$DEST/bin/postgres" -D "$DATADIR" -p 15432 &>/dev/null &
    while ! echo 'foo'|nc 127.0.0.1 15432;do
        sleep 1
    done
    sudo -u _postgres "$DEST/bin/createdb" -p 15432 2>/dev/null
    sudo killall postgres
}

[ "$1" == '--config' ]||_install;_config

#sudo rm -rf /var/postgres /var/log/postgres

