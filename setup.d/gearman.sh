#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://github.com/gearman/gearmand/releases/download/1.1.15/gearmand-1.1.15.tar.gz'
readonly DEST='/opt/gearman'
readonly BOOSTDIR='/opt/lib/boost'
readonly LIBEVENTDIR='/opt/lib/libevent'

_install(){
    cachegetfile "$URI" 'regdest'
    pushd "$regdest" >/dev/null

    l='uint64_t ntohll(uint64_t value)'
    f='./libgearman/byteorder.cc'
    p="$(cat <<'EOF'
#ifndef HAVE_HTONLL
uint64_t ntohll(uint64_t value)
{
    return swap64(value);
}

uint64_t htonll(uint64_t value)
{
    return swap64(value);
}
#endif
EOF
)"
    sed -i '/'"$(strings::escapebresed "$l")"'/,$d' "$f" 
    echo "$p" >>"$f"
    sed -i '$!N;/^\(.*\)\n\1$/!P;D' "$f"

    ./configure \
        --prefix="$DEST" \
        --with-boost="$BOOSTDIR" \
        LDFLAGS="-L$LIBEVENTDIR/lib" \
        CFLAGS="-I$LIBEVENTDIR/include" \
    && make -j2 \
        CXXFLAGS="-DHAVE_HTONLL=1 \
        -I$BOOSTDIR/include \
        -I$LIBEVENTDIR/include" \
        LDFLAGS="-L$BOOSTDIR/lib \
        -L$LIBEVENTDIR/lib" \
    && sudo make install \
    && make clean\
    && make distclean

    popd >/dev/null
}

_config(){
    dylibabspath "$DEST/bin" "$BOOSTDIR/lib"
    dylibabspath "$DEST/sbin" "$BOOSTDIR/lib"

    linkpkgconfig
    #linkbin 'gearman'
    #linkbin 'gearadmin'
    for v in 'gearman' 'gearadmin';do
        sudo rm -f "/usr/local/bin/$v" \
            && copyconfig "gearman/${v}.delegate" "/usr/local/bin/$v" \
            && chmod a+x "/usr/local/bin/$v"
    done
    
    adduser '_queue'
    for v in '/var/log/gearman' '/var/run/gearman';do
        [ -d "$v" ]||{ (umask 022;sudo mkdir "$v") \
            && sudo chown '_queue' "$v";}
    done
    if [ ! -f "$DEST/sbin/gearmand.rename" ];then
        sudo mv "$DEST/sbin/gearmand" "$DEST/sbin/gearmand.rename" \
        && copyconfig 'gearman/gearmand.delegate' "$DEST/sbin/gearmand" \
        && chmod a+x "$DEST/sbin/gearmand"
    fi


    #sudo rm -R '/var/log/gearman' '/var/run/gearman'

    copyconfig 'gearman/gearmand.conf' 'gearman/gearmand.conf'
    copyconfig 'gearman/gearmand.plist' '/Library/LaunchDaemons' \
        && sudo chown root:wheel '/Library/LaunchDaemons/gearmand.plist'
    copyuserconfig 'gearman/gearmandctl.sh' '.bashctl.d'

    
    if [ -d "$SUPERVISORPROGDIR" ];then
        copyconfig 'gearman/gearmanworker0.conf' "$SUPERVISORPROGDIR"
    fi
}

[ "$1" == '--config' ]||_install;_config



