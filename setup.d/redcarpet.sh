#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'

readonly DEST='/opt/redcarpet'

_bundleinstall(){
    local -r g="$1"
    local -r t="$(file::mktempdir)"    
    (cd "$t" \
        && { cat <<-EOF>'Gemfile'
		source 'https://rubygems.org'
		gem '$g'
		EOF
        } \
        && bundle config --local path 'vendor/bundle' \
        && bundle config --local bin 'bin' \
        && bundle install)
    
    (set -x;sudo mkdir -p "$DEST" \
        && sudo rsync -a "$t/" "$DEST" \
        && rm -R "$t")
}


_install(){
    _bundleinstall 'redcarpet'
}

_config(){
    :
}

[ "$1" == '--config' ]||_install;_config


