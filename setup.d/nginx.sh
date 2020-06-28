#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'


readonly URI='http://nginx.org/download/nginx-1.12.0.tar.gz'
readonly DEST='/opt/nginx'

cachegetfile "$URI" 'regdest'

readonly PCRESRC="$(file::abspath "$SRCDIR/pcre-8.39")"
readonly ZLIBSRC="$(file::abspath "$SRCDIR/zlib-1.2.11")"
readonly SSLDIR='/opt/openssl'

pushd "$regdest" >/dev/null||exit 1
./configure \
--prefix="$DEST" \
--with-cc-opt="-I$SSLDIR/include" \
--with-ld-opt="-L$SSLDIR/lib" \
--with-pcre="$PCRESRC" \
--with-zlib="$ZLIBSRC" \
--with-http_ssl_module \
--with-http_v2_module \
--conf-path=/usr/local/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--user=_www \
--group=_www \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--http-client-body-temp-path=/var/tmp/nginx/client \
--http-proxy-temp-path=/var/tmp/nginx/proxy \
--http-fastcgi-temp-path=/var/tmp/nginx/fastcgi \
--http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
--http-scgi-temp-path=/var/tmp/nginx/scgi \
&& make -j2 \
&& sudo make install \
&& make clean
popd >/dev/null
#--with-http_spdy_module \


linkbin "$DEST/sbin/nginx"

# Config
mkdir -p '/var/tmp/nginx'
sudo mkdir -p '/var/www'
copyconfig 'nginx/nginx.conf' 'nginx'
copyconfig 'nginx/sites-available/vh0' 'nginx/sites-available/vh0'
copyconfig 'nginx/sites-enabled/vh0' 'nginx/sites-enabled/vh0'
copyconfig 'nginx/nginx.plist' '/Library/LaunchDaemons' && sudo chown root:wheel '/Library/LaunchDaemons/nginx.plist'
copyuserconfig 'nginx/nginxctl.sh' '.bashctl.d'



