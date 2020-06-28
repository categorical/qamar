#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz'
readonly DEST='/opt/lib/libmcrypt'

cachegetfile "$URI" 'regdest'
makeminimal "$regdest"

