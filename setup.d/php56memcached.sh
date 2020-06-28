#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://pecl.php.net/get/memcached-2.2.0.tgz'
readonly PHPDIR='/opt/php56'
readonly LIBMEMCACHEDDIR='/opt/lib/libmemcached'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
"$PHPDIR/bin/phpize" \
&& ./configure \
--with-php-config="$PHPDIR/bin/php-config" \
--with-libmemcached-dir="$LIBMEMCACHEDDIR" \
--enable-memcached-igbinary \
--enable-memcached-json \
--enable-memcached-msgpack \
&& make \
&& sudo make install \
&& make clean \
&& make distclean
"$PHPDIR/bin/phpize" --clean
popd >/dev/null



