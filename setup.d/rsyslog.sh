#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'strings'


readonly URI='http://www.rsyslog.com/files/download/rsyslog/rsyslog-8.26.0.tar.gz'
readonly DEST='/opt/rsyslog'
#readonly JSONCDIR='/opt/lib/jsonc'

readonly LIBFASTJSONURI='http://download.rsyslog.com/libfastjson/libfastjson-0.99.5.tar.gz'
readonly LIBLOGGINGURI='http://download.rsyslog.com/liblogging/liblogging-1.0.6.tar.gz'

_installlibfastjson(){
    cachegetfile "$LIBFASTJSONURI" 'libfastjsondest'
    pushd "$libfastjsondest" >/dev/null||exit 1
    ./configure \
    --prefix="$libfastjsondir" \
    && make \
    && make install \
    && find "$libfastjsondir/lib" -mindepth 1 ! -name '*.a' -delete
    popd >/dev/null
}

_installliblogging(){
    cachegetfile "$LIBLOGGINGURI" 'libloggingdest'
    pushd "$libloggingdest" >/dev/null||exit 1
    ./configure \
    --prefix="$libloggingdir" \
    && make \
    && make install \
    && find "$libloggingdir/lib" -mindepth 1 ! -name '*.a' -delete
    popd >/dev/null
}


_install(){
    cachegetfile "$URI" 'regdest'
    pushd "$regdest" >/dev/null||exit 1
    
    local -r libfastjsondir="$(file::abspath './libfastjson')"
    local -r libloggingdir="$(file::abspath './liblogging')"
    _installlibfastjson;_installliblogging    

    f='./tools/Makefile.in'
    l='-Wl,--whole-archive,$(top_builddir)/runtime/.libs/librsyslog.a,--no-whole-archive'
    p="-Wl,-force_load,\$(top_builddir)/runtime/.libs/librsyslog.a"
    p+=",$libfastjsondir/lib/libfastjson.a"
    p+=",$libloggingdir/lib/liblogging-stdlog.a"
    sed -i "s/$(strings::escapebresed "$l")/$(strings::escapesed "$p")/" "$f"
    f='./configure'
    l='RSRT_CFLAGS=';p='" \$(LIBLOGGING_STDLOG_CFLAGS)"'
    sed -i "0,/^$(strings::escapebresed "$l").*\$/s//&$(strings::escapesed "$p")/" "$f" 

    #--disable-imttcp \
    #CC='/opt/gcc/bin/gcc' \
    ./configure \
    --prefix="$DEST" \
    --enable-omstdout \
    --enable-imfile \
    --disable-imptcp \
    --enable-omruleset \
    --disable-libgcrypt \
    --without-pic \
    JSON_C_CFLAGS="-I$libfastjsondir/include/libfastjson" \
    JSON_C_LIBS="-L$libfastjsondir/lib" \
    LIBLOGGING_STDLOG_CFLAGS="-I$libloggingdir/include" \
    LIBLOGGING_STDLOG_LIBS="-L$libloggingdir/lib"
    [ $? == 0 ]||exit 1

    f='./config.h'
    l='#define HAVE_FDATASYNC 1';p='#undef HAVE_FDATASYNC'
    sed -i "s/^$(strings::escapebresed "$l")\$/$(strings::escapesed "$p")/" "$f"
    l='#define HAVE_PTHREAD_SETNAME_NP 1';p='#undef HAVE_PTHREAD_SETNAME_NP'
    sed -i "s/^$(strings::escapebresed "$l")\$/$(strings::escapesed "$p")/" "$f"
    f='./plugins/mmexternal/mmexternal.c'
    l='#include <wait.h>';p='#include <sys/wait.h>'
    sed -i "s/^$(strings::escapebresed "$l")\$/$(strings::escapesed "$p")/" "$f"
    f='./tools/iminternal.c'
    l='r = pthread_mutex_timedlock(&mutList, &to);';p='r=pthread_mutex_trylock(&mutList);'
    sed -i "s/$(strings::escapebresed "$l")\$/$(strings::escapesed "$p")/" "$f"
    #l='to.tv_sec = time(NULL) + 1;'
    #sed -i "/$(strings::escapebresed "$l")\$/d" "$f"
    #l='to.tv_nsec = 0;'
    #sed -i "/$(strings::escapebresed "$l")\$/d" "$f"
    #l='struct timespec to;'
    #sed -i "/$(strings::escapebresed "$l")\$/d" "$f"
    
    make -j2 \
    && sudo make install \
    && make clean\
    && make distclean

    for v in "$libloggingdir" "$libfastjsondir";do
        [ ! -d "$v" ]||rm -R "$v"
    done
    popd >/dev/null


    # Version 8 does not build (out of the box) on macOS.
    # link: https://github.com/rsyslog/rsyslog/issues/1538

    # Legacy (version: 7.6.1) comment
    #Deps: libestr,liblogging,libuuid,json-c. Roughly...
    #NB:    1. Use CFLAGS,LDFLAGS,influential envs, etc. to resolve dependencies (configure and make).
    #       2. Solution of Duplicate Symbol error: --without-pic
}

_config(){
    adduser '_log'
    
    local datadir='/var/rsyslog/spool'
    sudo mkdir -p "`dirname "$datadir"`"
    for v in '/var/log/rsyslog' '/var/run/rsyslog' "$datadir";do
        [ -d "$v" ]||(umask 022;sudo mkdir "$v" && sudo chown _log "$v")
    done

    copyconfig 'rsyslog/conf.d/60-client.conf' 'rsyslog/conf.d/60-client.conf'
    copyconfig 'rsyslog/conf.d/70-server.conf' 'rsyslog/conf.d/70-server.conf'
    copyconfig 'rsyslog/rsyslog.conf' 'rsyslog/rsyslog.conf'

    copyconfig 'rsyslog/rsyslogd.plist' '/Library/LaunchDaemons' \
        && sudo chown root:wheel '/Library/LaunchDaemons/rsyslogd.plist'
    copyuserconfig 'rsyslog/rsyslogdctl.sh' '.bashctl.d'
    
    { [ -f "$DEST/sbin/rsyslogd.rename" ] \
        || sudo mv "$DEST/sbin/rsyslogd" "$DEST/sbin/rsyslogd.rename";} \
        && copyconfig 'rsyslog/rsyslogd.delegate' "$DEST/sbin/rsyslogd"

    
    #sudo rm -R /var/log/rsyslog /var/rsyslog/spool
}

[ "$1" == '--config' ]||_install;_config


