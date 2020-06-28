#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file'


readonly URI='http://fi2.php.net/get/php-5.6.30.tar.xz/from/this/mirror'
readonly DEST='/opt/php56'

readonly FREETYPEDIR='/opt/lib/freetype'
readonly LIBPNGDIR='/opt/lib/libpng'
readonly LIBJPEGDIR='/opt/lib/libjpeg'
readonly LIBMCRYPTDIR='/opt/lib/libmcrypt'
readonly CURLDIR='/opt/curl'
readonly READLINEDIR='/opt/lib/readline'
readonly APACHE2DIR='/opt/apache2'
readonly NGHTTP2DIR='/opt/lib/nghttp2'
readonly PCREDIR='/opt/lib/pcre'
readonly SSLDIR='./openssl'

#readonly OPENSSLURI='https://www.openssl.org/source/openssl-1.0.2k.tar.gz'
readonly OPENSSLURI='https://www.openssl.org/source/old/0.9.x/openssl-0.9.8zh.tar.gz'
_installopenssl(){
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
    pushd "$regdest" >/dev/null
    
    local -r openssldir="$(file::abspath './openssl')"
    _installopenssl
    
    CPPFLAGS="-I$NGHTTP2DIR/include" \
    LDFLAGS="-L$NGHTTP2DIR/lib" \
    ./configure \
    --prefix="$DEST" \
    --with-config-file-path='/usr/local/etc/php56' \
    --with-mysql \
    --with-pdo-mysql \
    --with-mysql-sock='/var/run/mysql/mysql.sock' \
    --with-gd \
    --with-freetype-dir="$FREETYPEDIR" \
    --with-png-dir="$LIBPNGDIR" \
    --with-jpeg-dir="$LIBJPEGDIR" \
    --with-curl="$CURLDIR" \
    --with-mcrypt="$LIBMCRYPTDIR" \
    --with-openssl="$SSLDIR" \
    --with-apxs2="$APACHE2DIR/bin/apxs" \
    --with-readline="$READLINEDIR" \
    --enable-fpm \
    --enable-bcmath \
    --enable-mbstring \
    --enable-mbregex \
    && LDFLAGS="-L$NGHTTP2DIR/lib" \
    make -j5 \
    && sudo make install \
    && make clean \
    && make distclean
    [ ! -d "$openssldir" ]||(set -x;rm -R "$openssldir")
    popd >/dev/null
}


_config(){
    linkbin 'php' 'php56'
    linkbin 'phpize' 'php56ise'   
 
    sudo mkdir -p '/var/log/php56fpm'
    copyconfig 'php56/php.ini' 'php56/php.ini'
    copyconfig 'php56/fpm/php-fpm.conf' 'php56/fpm/php-fpm.conf'
    copyconfig 'php56/php56fpm.plist' '/Library/LaunchDaemons' \
        && sudo chown root:wheel '/Library/LaunchDaemons/php56fpm.plist'
    copyuserconfig 'php56/php56fpmctl.sh' '.bashctl.d'
    
    [ ! -d '/var/www' ]||copyconfig 'php56/info.php' '/var/www'
}

[ "$1" == '--config' ]||_install;_config


