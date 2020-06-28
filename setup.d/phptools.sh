#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly DEST="$HOME/bin"
#readonly DEST='/opt/phptools'
readonly PHPDIR='/opt/php56'

_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}

#sudo -k
#sudo mkdir -p "$DEST"||exit 1
mkdir -p "$DEST"

URI='https://getcomposer.org/download/1.4.1/composer.phar'
ITEM='composer'
cacheget "$URI" '_getfile' 'regdest'
cp "$regdest" "$DEST"
copyuserconfig 'composer/config.json' '.composer/config.json'
# config.json creates a folder named "cache" at COMPOSER_HOME,
# unless COMPOSER_CACHE_DIR is also set.
setenv 'COMPOSER_CACHE_DIR' '$HOME/Library/Caches/composer'
setalias "$ITEM" "$PHPDIR/bin/php $DEST/${ITEM}.phar"
out::info "$(printf 'installed: %s\n' "$ITEM")"
# If DEST requires root write access, 
# self-update would need root privilege to deploy a new executable there.
# Running self-update as root has problems:
# 1. composer is not available to root if it is defined as an alias.
# 2. Environment variables are lost, unless sudo's -E (or -H) flag is set (man 8 sudo).
# 3. The cache folder will be created with root (write) access.

# rm -R "$HOME/.composer" "$HOME/Library/Caches/composer"



