#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='https://github.com/phalcon/cphalcon/archive/phalcon-v1.3.4.tar.gz'
readonly PHPDIR='/opt/php56'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
(cd 'build/64bits' \
    && "$PHPDIR/bin/phpize" \
    && ./configure \
        --with-php-config="$PHPDIR/bin/php-config" \
        --enable-phalcon \
    && make \
    && sudo make install \
    && make clean \
    && make distclean
    "$PHPDIR/bin/phpize" --clean)
popd >/dev/null

