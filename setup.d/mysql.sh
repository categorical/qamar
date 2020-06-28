#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly URI='https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.18.tar.gz'
readonly DEST='/opt/mysql'

readonly BOOSTURI='http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.bz2'
readonly BOOSTNAME='boost_1_59_0.tar.gz'
readonly DATADIR='/var/mysql/data'


_install(){
    
    cachegetfile "$URI" 'regdest'
    # Downloads Boost 1.59.0.
    #readonly BOOSTURI='https://github.com/boostorg/boost/archive/boost-1.59.0.tar.gz'
    _getboost(){
        http::downloadfile "$BOOSTURI" "$DISTDIR" 'nil' 'boostdist'||exit 1
    }
    cacheget "$BOOSTURI" '_getboost' 'boostdist'
    boostdist="$(file::abspath "$boostdist")"

    pushd "$regdest" >/dev/null||exit 1
    (mkdir -p bld \
        && cd bld \
        && cp "$boostdist" "$BOOSTNAME" \
        && cmake '..' \
            -DCMAKE_INSTALL_PREFIX="$DEST" \
            -DWITH_BOOST="$BOOSTNAME" \
            -DMYSQL_DATADIR="$DATADIR" \
        && make -j3 \
        && sudo make install \
        && make clean)
    rm -Rf bld
    popd >/dev/null
    #-DDOWNLOAD_BOOST=1 \
}

_config(){
    # Config
    linkbin "$DEST/bin/mysql"
    copyconfig 'mysql/mysql.plist' '/Library/LaunchDaemons' && sudo chown root:wheel '/Library/LaunchDaemons/mysql.plist'
    copyuserconfig 'mysql/mysqlctl.sh' '.bashctl.d'
    copyconfig 'mysql/my.cnf' 'mysql/my.cnf' \
    && sudo mkdir -p "$DEST/etc" \
    && sudo ln -sf '/usr/local/etc/mysql/my.cnf' "$DEST/etc/my.cnf"
    # The control script support-files/mysql.server invokes bin/my_print_defaults which reads config file at /opt/mysql/etc/my.cnf.
    copyconfig 'mysql/resetpassword.sql' "$DEST/etc/resetpassword.sql"

    sudo mkdir -p "`dirname "$DATADIR"`"
    for v in "$DATADIR" '/var/log/mysql' '/var/run/mysql';do
        [ -d "$v" ]||{ (umask 066;sudo mkdir "$v") \
            && sudo chown _mysql "$v";}
    done
   
    if [ ! -f "$DEST/bin/mysqld_safe.rename" ];then 
        sudo mv "$DEST/bin/mysqld_safe" "$DEST/bin/mysqld_safe.rename" \
        && copyconfig 'mysql/mysqld_safe.delegate' "$DEST/bin/mysqld_safe"
    fi

    # Database
    sudo killall mysqld 2>/dev/null
    if [ -z "$(sudo ls -A "$DATADIR" 2>/dev/null)" ];then
        sudo "$DEST/bin/mysqld" --initialize >/dev/null
    fi
    
    (sudo "$DEST/support-files/mysql.server" start --init-file="$DEST/etc/resetpassword.sql" \
        && sudo "$DEST/support-files/mysql.server" stop)>/dev/null
}


[ "$1" == '--config' ]||_install;_config

#sudo rm -rf /var/mysql /var/log/mysql /var/run/mysql


