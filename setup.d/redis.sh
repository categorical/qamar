#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'


readonly URI='http://download.redis.io/releases/redis-3.2.8.tar.gz'
readonly DEST='/opt/redis'

cachegetfile "$URI" 'regdest'


pushd "$regdest" >/dev/null||exit 1
make -j2 \
&& sudo make PREFIX="$DEST" install \
&& make distclean
popd >/dev/null


linkbin "$DEST/bin/redis-cli"

# Config
[ -d '/var/redis' ]||sudo mkdir '/var/redis'
copyconfig 'redis/redis.conf' 'redis/redis.conf'

copyconfig 'redis/redis.plist' '/Library/LaunchDaemons' && sudo chown root:wheel '/Library/LaunchDaemons/redis.plist'
copyuserconfig 'redis/redisctl.sh' '.bashctl.d'

