#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='http://pecl.php.net/get/intl-3.0.0.tgz'
readonly PHPDIR='/opt/php56'
readonly ICUDIR='/opt/lib/icu4c'


cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
"$PHPDIR/bin/phpize" \
&& ./configure \
--with-php-config="$PHPDIR/bin/php-config" \
ICU_CONFIG="$ICUDIR/bin/icu-config" \
CXXFLAGS='-std=c++11' \
&& make \
&& sudo make install
"$PHPDIR/bin/phpize" --clean
popd >/dev/null



