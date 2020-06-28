#!/bin/bash

. `dirname $0`/env.sh
import 'http' 'file' 'out' 'strings'

readonly URI='http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-macosx-x64.dmg'
readonly COOKIE='oraclelicense=accept-securebackup-cookie'
readonly DEST='/opt/jdk8'

_getfile(){
    http::downloadfile "$URI" "$DISTDIR" 'nil' 'regdest'
}

_installpkg(){
    file::installpkg "$1"
    #/usr/libexec/java_home
}

_removepkg()(
    set -x
    sudo rm -Rf /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
    sudo rm /Library/LaunchDaemons/com.oracle.java.Helper-Tool.plist
    sudo rm /Library/LaunchAgents/com.oracle.java.Java-Updater.plist
    sudo rm /Library/PreferencePanes/JavaControlPanel.prefpane
    sudo rm -Rf /Library/Java/JavaVirtualMachines/*
    sudo rm -Rf /Library/Application\ Support/Oracle
    sudo pkgutil --forget com.oracle.jdk8u131
    sudo pkgutil --forget com.oracle.jre
)

_unpackpkg(){
    _install(){
        local d="$(ls -d jdk*/Contents/Home|tail -n1)"
        [ -d "$d" ]||return 1
        
        sudo mkdir -p "$DEST" \
        && sudo cp -Rv "$d/" "$DEST"

        # IntelliJ identifies JVM by this file.
        local f="$d/../Info.plist"
        if [ -f "$f" ];then
            local k='<key>CFBundleExecutable</key>'
            local v="<string>$DEST/jre/lib/jli/libjli.dylib</string>"
            cat "$f" \
                |sed "/$(strings::escapebresed "$k")/!b;n;c$(strings::escapesed "$v")" \
                |sudo tee >/dev/null "$DEST/info.plist"
            # IDEA requires this hierachy to load JDK libraries. 
            (cd "$DEST" \
                && sudo mkdir -p './Contents/Home' \
                && sudo ln -sf '../info.plist' './Contents' \
                && sudo ln -sf '../../lib' './Contents/Home')
            # Eclipse requires this hard link.
            (cd "$DEST/Contents/Home" \
                && sudo mkdir -p './bin' \
                && sudo ln -f '../../bin/java' './bin' \
                && sudo ln -sf '../../jre')
        fi
        
    }
    file::withpkg "$1" '_install'
}

_config(){
    setenv 'JAVA_HOME' "$DEST"
    linkbin 'javadoc'
    linkbin 'javac'
    linkbin 'java'
}

_remove(){
    (set -x;sudo rm -R '/opt/jdk8')
}


case $1 in
    '--installpkg')
        cacheget "$URI" '_getfile' 'regdest'
        file::withdmg "$regdest" '_installpkg';;
    '--removepkg')
        _removepkg;;
    '--remove')
        _remove;;
    '--config')
        _config;;
    *)  cacheget "$URI" '_getfile' 'regdest'
        file::withdmg "$regdest" '_unpackpkg';_config;;
esac



