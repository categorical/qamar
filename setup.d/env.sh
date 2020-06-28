#!/bin/bash

WORKDIR="`dirname ${BASH_SOURCE[0]}`/.."
source $WORKDIR/../tenochtitlan/import.sh ''

import 'kv' 'out' 'http' 'file' 'ftp' 'strings'

declare -r WORKDIR="$(file::abspath "$WORKDIR")"
declare -r DISTDIR=$WORKDIR/dist
declare -r SRCDIR=$WORKDIR/src
declare -r CONFIGDIR=$WORKDIR/config

declare -r PKGCONFIGLIBDIR=/opt/lib/pkgconfig
declare -r SUPERVISORPROGDIR=/usr/local/etc/supervisor/conf.d


kv::setfile "$WORKDIR/.cacheuri"

_onexit(){
    if [ "$?" -eq 0 ];then
        out::info 'exited 0'       
    else
        out::error 'epic fail'
    fi
}
trap '_onexit' EXIT


# @param $1 uri
# @param $2 *callback
# @param $3 *dest
function cacheget(){
    local u=$1
    local c=$2
    local d=$3
    local _regdest
    if ! _regdest=$(kv::get "$u") || [ ! -e "$_regdest" ];then
        "$c"||exit 1
        kv::set "$u" "$(file::abspath "${!d}")"
    else
        printf -v "$d" '%s' "$_regdest"
    fi
}

# @param $1 uri
# @param $2 *dest
function cachegetfile(){
    local u=$1
    local d=$2
    _c(){
        case $u in
            http*)
                http::downloadfile "$u" "$DISTDIR" 'nil' "$d"||exit 1
                ;;
            ftp*)
                ftp::downloadfile "$u" "$DISTDIR" 'nil' "$d"||exit 1
                ;;
            *)  exit 1
                ;;
        esac
    }
    cacheget "$u" '_c' "$d"   
    
    if ! file::unpack ${!d} "$SRCDIR" "$d";then
        exit 1
    fi
}

# @param $1 source filename
# @param $2 dest filename
function linkbin(){
    local s="$1";[[ "$1" =~ ^/.*$ ]]||s="$DEST/bin/$s"
    [ -f "$s" ]||return 1

    local d='/usr/local/bin'
    if [ -n "$2" ];then
        if [[ "$2" =~ ^/.*$ ]];then
            d="$2"
        else
            d="$d/$2"
        fi
    fi
    
    sudo ln -sf "$s" "$d"
}

# @param $@ source filename(s)
function linkpkgconfig(){
    local d="$DEST/lib/pkgconfig"
    
    local fs;if [ "$#" -gt 0 ];then
        local n;for n in "$@";do
            fs+=("$d/$n")
        done
    else
        fs=("$d/"*.pc)
    fi

    local f;for f in "${fs[@]}";do
        [ ! -f "$f" ]||sudo ln -sf "$f" "$PKGCONFIGLIBDIR"
    done
}

# @param $1 source file
# @param $2 dest file
function copyuserconfig(){
    local s="$1";[[ "$s" =~ ^/.*$ ]]||s="$CONFIGDIR/$s"
    local d="$2";[[ "$d" =~ ^/.*$ ]]||d="$HOME/$d"
    [ -f "$s" ]||return 1
    mkdir -p "$(dirname "$d")" && cp "$s" "$d"
}
function copyconfig(){
    local s="$1";[[ "$s" =~ ^/.*$ ]]||s="$CONFIGDIR/$s"
    local d="$2";[[ "$d" =~ ^/.*$ ]]||d="/usr/local/etc/$d"
    [ -f "$s" ]||return 1
    sudo mkdir -p "$(dirname "$d")" && sudo cp -a "$s" "$d"
}


# @param $1 source dir
function makeminimal(){
    local s="$1";[ -d "$s" ]||exit 1
    
    pushd "$s" >/dev/null||exit 1
    ./configure \
    --prefix="$DEST" \
    && make -j2 \
    && sudo make install \
    && make clean\
    && make distclean
    popd >/dev/null
}


# @param $1 source dir
function cmakeminimal(){
    local s="$1";[ -d "$s" ]||exit 1
    
    pushd "$s" >/dev/null||exit 1
    (mkdir -p bld \
        && cd bld \
        && cmake '..' \
            -DCMAKE_INSTALL_PREFIX="$DEST" \
        && make -j2 \
        && sudo make install \
        && make clean)
    rm -Rf bld
    popd >/dev/null
}

# @param $1 k
# @param $2 v
function setenv(){
    local k="$1" v="$2"
    [[ $k =~ ^[A-Z_]{4,}$ ]]||exit 1
    local f="$HOME/.bash_env"
    local kescaped=$(strings::escapebresed "$k")
    if [ "$v" == "${v/'$'}" ];then
        v="'$v'"
    else
        v="\"$v\""
    fi

    if egrep "^export $kescaped=.*$" "$f">/dev/null;then
        local sed='/usr/bin/sed'
        $sed -i '' "s/^\(export $kescaped=\).*$/\1$(strings::escapesed "$v")/" "$f"
    else
        printf '%s\n' "export $k=$v" >>"$f"
    fi
}

# @param $1 k
# @param $2 v
function setalias(){
    local k="$1" v="$2"
    [[ $k =~ ^[a-z_]{1,}$ ]]||exit 1
    local f="$HOME/.bash_aliases"
    local kescaped=$(strings::escapebresed "$k")
    local s="'"
    v="$s${v//$s/$s\"$s\"$s}$s"
    if egrep "^alias $kescaped=.*$" "$f">/dev/null;then
        local sed='/usr/bin/sed'
        $sed -i '' "s/^\(alias $kescaped=\).*$/\1$(strings::escapesed "$v")/" "$f"
    else
        printf '%s\n' "alias $k=$v" >>"$f"
    fi
}

# @param $1 k
# @param $2 v
function setfunc(){
    local k="$1" v="$2"
    [[ $k =~ ^[a-z_]{2,}$ ]]||exit 1
    local f="$HOME/.bash_functions"
    local kescaped=$(strings::escapebresed "$k")
    local s='#THIS IS A WALL'
    if egrep "^function $kescaped().*$" "$f">/dev/null;then
        local sed='/usr/bin/sed'
        $sed \
            -i '' \
            -e "/^$(strings::escapebresed "$s")/,\$!b" \
            -e "/^function $kescaped()/,/^#noitcnuf/c\\
            function $kescaped()$(strings::escapesed "$v")\\
            #noitcnuf" "$f"
    else
        printf '%s\n#noitcnuf\n\n' "function $k()$v" >>"$f"
    fi
}


# @param $1 
# @param $@ search path(s)
function dylibabspath(){
    local search=("$@")
    local d="$1"
    if [ -z "$1" ];then
        search+=("$DESt/lib")
        d="$DEST/lib"
    fi
    local n m f

    _evaluatepath(){
        local m="$1"
        m="${m#'@rpath/'}"
        [ "${m:0:1}" != '/' ]||return 1
       
        local found= 
        local v;for v in "${search[@]}";do
            [ -d "$v" ]||continue
            if [ -f "$v/$m" ];then
                m="$v/$m";found='t'
                break
            fi
        done

        [ "$found" == 't' -a -f "$m" ]||return 1
        if [ -L "$m" ];then
            local t;t="$(readlink "$m")"
            if [ "${t:0:1}" == '/' ];then
                m="$t"
            else
                m="`dirname "$m"`/$t"
            fi
        fi
        m="$(file::abspath "$m")"
        printf '%s' "$m"
    }

    while IFS= read -d $'\0' -r f;do
    #for f in "$d"/*.dylib;do
        [ -f "$f" ]||continue
        [ ! -L "$f" ]||continue
        
        n="$(otool -D "$f"|tail -n1)"
        if m="$(_evaluatepath "$n")";then
            sudo install_name_tool -id "$m" "$f"||return 1
            out::info "$(printf '%-30s:%-30s->%s' `basename "$f"` "$n" "$m")"
        fi
        declare ns;IFS=$'\n' read -d $'\0' -ra ns \
            <<< "$(otool -L "$f" |cut -sd$'\t' -f2|cut -d' ' -f1)"
        for n in "${ns[@]}";do
            m="$(_evaluatepath "$n")"||continue
            sudo install_name_tool -change "$n" "$m" "$f"||return 1
            out::info "$(printf '%-30s:%-30s->%s' `basename "$f"` "$n" "$m")"
        done
    done < <(find "$d" -type f -maxdepth 1 -mindepth 1 \( -perm +100 -o -name '*.dylib' \) -print0)
}


function adduser(){
    [ -n "$1" ]||return 1

    local d="$WORKDIR/../xaltelolco"
    (sudo "$d/user.sh" add "$1")
    if [ -n "$("$d/users.sh"|grep "$1")" ];then
        out::info "$(printf 'user found: %s' "$1")"
    else  
        out::error "$(printf 'user not found: %s' "$1")"
        return 1
    fi
}

function addhost(){
    local i="$1" h="$2"
    [ -n "$i" -a -n "$h" ]||return 1
    local -r f='/etc/hosts'
                                            
    local hescaped="$(strings::escapebre "$h")"                        
    if egrep -o "[[:space:]]$hescaped[[:space:]]?" "$f" >/dev/null;then
        :
    else
        cat <<-EOF |sudo tee -a "$f" >/dev/null
		$i	$h
		EOF
    fi
}

# $1 host
# $2 uri
function setvhost(){
    local h=$1 uri=$2
    [ -n "$h" -a -n "$uri" ]||return 1

    local f='/usr/local/etc/nginx/sites-available/reverse'
    local l='/usr/local/etc/nginx/sites-enabled/reverse'
    [ -d "$(dirname "$f")" -a -d "$(dirname "$l")" ]||return 1
    sudo touch "$f" && sudo ln -sf "$f" "$l"
    addhost '127.0.0.1' "$h" 

    local b="$(cat <<EOF
#server:$h
server {
    listen 80;
    server_name $h;
    location / {
        proxy_pass $uri;
    }
}
#revres
EOF
)"$'\n'
    local hescaped="$(strings::escapebresed "$h")"
    if egrep "^#server:$hescaped.*$" "$f">/dev/null;then
        local sed='/usr/bin/sed'
        sudo $sed \
            -i '' \
            -e "/^#server:$hescaped/,/^#revres/c\\
            $(strings::escapesed "$b")" "$f"
    else
        printf '%s\n' "$b"|sudo tee -a "$f" >/dev/null
    fi
     
}


