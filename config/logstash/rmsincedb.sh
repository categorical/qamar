#!/bin/bash

if [ -z "$1" ];then
    echo "Usage: $0 [foo.conf]"
    exit 1
fi

f=$(cat "$1"|grep 'sincedb_path'|awk '{print $NF}'|sed 's/"//g')
if [ -f "$f" ];then
    (set -x;sudo rm "$f")
fi

