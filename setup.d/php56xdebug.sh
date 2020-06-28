#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://pecl.php.net/get/xdebug-2.5.3.tgz'
readonly PHPDIR='/opt/php56'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
"$PHPDIR/bin/phpize" \
&& ./configure \
--with-php-config="$PHPDIR/bin/php-config" \
&& make \
&& sudo make install \
&& make clean \
&& make distclean
"$PHPDIR/bin/phpize" --clean
popd >/dev/null

