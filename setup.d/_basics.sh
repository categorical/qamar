#!/bin/bash

. `dirname $0`/env.sh
import 'out'


_config(){
    
    

    local -r ctldef="$(cat <<'EOF'
(
    local item="$1";shift
    if [ -z "$item" ];then
        echo "usage: $FUNCNAME item args..." >&2
        return 1
    fi
    local -r itemdir="$HOME/.bashctl.d"
    local itemfile="${itemdir}/${item}ctl.sh"
    if [ ! -f "$itemfile" ];then
        echo 'item not found' >&2
        return 1
    fi
    source "$itemfile" \
    && ITEM="$item" CTL="$FUNCNAME" _run "$@"
)
EOF
)"
    setfunc 'ctl' "$ctldef"
}

_config

