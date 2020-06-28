#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://nodejs.org/dist/v7.9.0/node-v7.9.0.tar.gz'
readonly DEST='/opt/nodejs'


readonly PYTHON2='/opt/python27/bin/python2'


_install()(
    cachegetfile "$URI" 'regdest'

    pushd "$regdest" >/dev/null||exit 1
    
    # BUG
    # subject: Node.js (installation) has a dependency on Xcode
    # version: macOS 10.12.3
    # desc: 
    #   xcode-select -p gives /Library/Developer/CommandLineTools.
    #   Running the configure script yields error message: xcodebuild requires Xcode.
    #   Issues existed for years, despite being closed.
    # link: https://github.com/nodejs/node-gyp/issues/569
    # solution: short circuit xcodebuild (worked for me).
    # 
    mkdir -p 'patch' \
        && { cat <<-'EOF'> 'patch/xcodebuild'
			#!/bin/bash
			exit 0
			EOF
        } \
        && chmod a+x 'patch/xcodebuild' \
        && export PATH="$(pwd)/patch:$PATH"
    
    #export PYTHON="$PYTHON2" # Legacy script included this line. 
    "$PYTHON2" ./configure \
        --prefix="$DEST" \
        --dest-cpu=x64 \
        --dest-os=mac \
        && make -j5 \
        && sudo make install \
        && make clean\
        && make distclean
    popd >/dev/null
)

_config(){
    linkbin 'node'
    linkbin 'npm'
    copyuserconfig 'npm/npmrc' '.npmrc'
    copyconfig 'npm/npmrc' "$DEST/etc/npmrc"
}

[ "$1" == '--config' ]||_install;_config
