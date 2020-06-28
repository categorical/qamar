#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='ftp://ftp.gnu.org/gnu/grep/grep-2.26.tar.xz'
readonly DEST='/opt/gnu/grep'


_install(){
    cachegetfile "$URI" 'regdest'
    makeminimal "$regdest"
}

_config(){
    linkbin 'grep'

    # If stdin is attached to terminal,
    # i.e. not from a pipeline: 
    # grep args     -> grep opts args [|grep opts];
    # otherwise, grep's stdin is from a pipeline (,and not from a script):
    # foo|grep args -> foo|grep opts|grep opts args.
    # 
    # The goal here is to expand grep with opts,
    # but the args as a string needs to be put at different places for the two cases.
    # This is accomplised by the function _:
    # grep args     -> _(){ :;};_ args,
    # however, this will not work for a pipeline:
    # foo|grep args -> foo|_(){ :;};_ args,
    # it has to be:
    # foo|grep args -> foo|{ _(){ :;};_ args;},
    # but this is not alias expansion.
    # 
    # The association of _(){ :;} and _ can be done with eval,
    # not requiring enclosing parentheses:
    # grep args     -> eval '_(){ :;};_' args
    # foo|grep args -> foo|eval '_(){ :;};_' args
    #
    # Epic fail: eval's args are no longer quoted upon evaluation.
    #
#    setalias 'grep' "eval '_(){ if [ -t 0 ];\
#then command grep --colour=always --line-buffered \"\$@\";\
#else command grep -v grep --line-buffered|command grep --colour=always --line-buffered \"\$@\";\
#fi;unset -f _;};_'"
        

    local -r t="$(cat <<'EOF'
{
    if [ -t 0 ];then
        command grep --colour=always --line-buffered "$@"
    else
        command grep -v grep --line-buffered|command grep --colour=always --line-buffered "$@"
    fi
}
EOF
)"
    setfunc 'grep' "$t"
    setenv 'GREP_COLOR' '00;32'
}

[ "$1" == '--config' ]||_install;_config

