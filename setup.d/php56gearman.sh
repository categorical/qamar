#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://pecl.php.net/get/gearman-1.1.2.tgz'
readonly PHPDIR='/opt/php56'
readonly GEARMANDIR='/opt/gearman'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
"$PHPDIR/bin/phpize" \
&& ./configure \
--with-php-config="$PHPDIR/bin/php-config" \
--with-gearman="$GEARMANDIR" \
&& make \
&& sudo make install \
&& make clean \
&& make distclean
"$PHPDIR/bin/phpize" --clean
popd >/dev/null



