#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://pecl.php.net/get/redis-3.1.2.tgz'
readonly PHPDIR='/opt/php56'


cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
"$PHPDIR/bin/phpize" \
&& ./configure \
--with-php-config="$PHPDIR/bin/php-config" \
&& make \
&& sudo make install
"$PHPDIR/bin/phpize" --clean
popd >/dev/null



