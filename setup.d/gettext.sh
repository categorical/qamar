#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly URI='ftp://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.8.1.tar.xz'
readonly DEST='/opt/gnu/gettext'

cachegetfile "$URI" 'regdest'

makeminimal "$regdest"

linkbin 'xgettext'
linkbin 'msgmerge'
linkbin 'msgfmt'


