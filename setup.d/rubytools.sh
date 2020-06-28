#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly DEST='/opt/rubytools'
setenv 'GEM_PATH' "$DEST"

sudo -k
ITEM='bundler'
sudo gem install "$ITEM" --install-dir="$DEST"
copyuserconfig 'bundler/config' '.bundle/config'
linkbin 'bundle'
out::info "$(printf 'installed: %s.' "$ITEM")"


