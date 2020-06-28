#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'


readonly URI='http://mirror.netcologne.de/apache.org//httpd/httpd-2.4.25.tar.bz2'
readonly DEST='/opt/apache2'


readonly APRURI='http://ftp.fau.de/apache//apr/apr-1.5.2.tar.bz2'
readonly APRUTILURI='http://ftp.fau.de/apache//apr/apr-util-1.5.4.tar.bz2'
readonly OPENSSLURI='https://www.openssl.org/source/old/0.9.x/openssl-0.9.8zh.tar.gz'

readonly PCREDIR='/opt/lib/pcre'
readonly NGHTTP2DIR='/opt/lib/nghttp2'
SSLDIR=

_installopenssl(){
    #readonly OPENSSLURI='https://www.openssl.org/source/openssl-1.0.2k.tar.gz'
    cachegetfile "$OPENSSLURI" 'openssldest'
    [ -n "$openssldir" ]||exit 1
    pushd "$openssldest" >/dev/null||exit 1
    ./Configure \
    darwin64-x86_64-cc \
    enable-ec_nistp_64_gcc_128 \
    no-ssl3 \
    --prefix="$openssldir" \
    && make depend \
    && make install \
    && make clean
    popd >/dev/null
}


_install(){
    cachegetfile "$URI" 'regdest'
    cachegetfile "$APRURI" 'aprdest'
    cachegetfile "$APRUTILURI" 'aprutildest'
    aprdest="$(file::abspath "$aprdest")"
    aprutildest="$(file::abspath "$aprutildest")"
    
    pushd "$regdest" >/dev/null||exit 1
    cp -R "$aprdest/" './srclib/apr'
    cp -R "$aprutildest/" './srclib/apr-util'
   
    local -r openssldir="$(file::abspath './openssl')"
    _installopenssl

    SSLDIR="$openssldir"
    #sed -i 's/CRYPTO_malloc_init/OPENSSL_malloc_init/g' './support/ab.c'
    #sed -i 's/BN_num_bits(dhparams->p)/DH_bits(dhparams)/g' './modules/ssl/ssl_engine_init.c'
    #CPPFLAGS=-DOPENSSL_NO_SSL2 \
    ./configure \
    --prefix="$DEST" \
    --with-pcre="$PCREDIR" \
    --with-included-apr \
    --with-nghttp2="$NGHTTP2DIR" \
    --with-ssl="$SSLDIR" \
    --enable-so \
    --enable-proxy \
    --enable-rewrite \
    --enable-http2 \
    --enable-ssl \
    --enable-ssl-staticlib-deps \
    --enable-mods-static=ssl \
    && make \
    && sudo make install \
    && make clean \
    && make distclean
    [ ! -d "$openssldir" ]||rm -vR "$openssldir"
    popd >/dev/null
}

_config(){
    linkbin "$DEST/bin/ab"

    sudo mkdir -p '/var/www' '/var/log/httpd'
    addhost '127.0.0.1' 'vh0'
    copyconfig 'apache2/httpd.conf' 'httpd/httpd.conf'
    copyconfig 'apache2/sites-available/vh0' 'httpd/sites-available/vh0'
    copyconfig 'apache2/sites-enabled/vh0' 'httpd/sites-enabled/vh0'
    copyconfig 'apache2/extra/php5.conf' 'httpd/extra/php5.conf'
    copyconfig 'apache2/apache2.plist' '/Library/LaunchDaemons' \
        && sudo chown root:wheel '/Library/LaunchDaemons/apache2.plist'
    copyuserconfig 'apache2/apache2ctl.sh' '.bashctl.d'
}

[ "$1" == '--config' ]||_install;_config


