#!/bin/bash


{ . `dirname $0`/setup.d/env.sh;trap - EXIT;}
import 'out' 'argparse' 'dict'


argparse::add '--list' 'storetrue'
argparse::add '--install'
argparse::add '--clean' 'storetrue'
argparse::addconstraint 'exclusive' '--list' '--install' '--clean'
argparse::parse "$@"


readonly ITEMDIR="$WORKDIR/setup.d"

if item="$(argparse::get '--install')";then
    f="$ITEMDIR/${item}.sh"
    if [ -x "$f" ];then
        msg="$(printf 'installation begins soon: %s' "$item")"
        for ((i=0;i<4;i++));do
            msgs+=("$msg $(printf "%${i}s"|tr ' ' '.')")
        done
        msgs+=("YOU'RE ALL GOING TO DIE DOWN HERE.")
        { out::tick 'out::infocr' "${msgs[@]}";echo;}
        "$f"
    else
        out::error 'unknown item' "$item"
    fi
elif [ "$(argparse::get '--clean')" == 't' ];then
    for d in "$SRCDIR"/*;do
        [ -d "$d" ]||break
        (set -x; rm -R "$d")||exit 1
    done
else
    fs=($(find "$ITEMDIR" -type f -maxdepth 1 -mindepth 1 -perm +100 ! -name `basename $0`))
    for f in "${fs[@]}";do
        f=`basename "$f"`
        echo "$(printf '%s\n' "${f%.sh}")"
    done|sort
fi



