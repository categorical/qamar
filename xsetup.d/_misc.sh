#!/bin/bash

. `dirname $0`/env.sh
import 'out'

_aliasq(){
    touch "$HOME/.aliasq"
    setalias 'q' 'function _() { [ "$#" -gt 0 ]&&cat "$HOME"/.aliasq|fgrep -A4 --colour=always -- "$*"; unset -f _;}; _'

};_aliasq


_homebin(){
    setenv 'PATH' '$PATH:$HOME/bin'

};_homebin





