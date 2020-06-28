#!/bin/bash

. `dirname $0`/env.sh
import 'out'

readonly DEST='/opt/golangtools'
export GOPATH="$DEST"

sudo -k
URI='github.com/tools/godep'
ITEM="`basename "$URI"`"
sudo -E go get "$URI"
linkbin "$ITEM"
out::info "$(printf 'installed: %s.' "$ITEM")"



