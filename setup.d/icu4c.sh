#!/bin/bash

. `dirname $0`/env.sh
import 'out' 'file'


readonly URI='http://download.icu-project.org/files/icu4c/59.1/icu4c-59_1-src.tgz'
readonly DEST='/opt/lib/icu4c'

cachegetfile "$URI" 'regdest'

pushd "$regdest" >/dev/null||exit 1
cd "$regdest/source" \
&& LDFLAGS='-headerpad_max_install_names' \
./runConfigureICU MacOSX/GCC \
--prefix="$DEST" \
&& make -j2 \
&& sudo make install \
&& make clean \
&& make distclean
popd >/dev/null

linkpkgconfig

dylibabspath # Requires linker option: -headerpad_max_install_names.  

# icu bug:
# desc: installed libraries have relative install path
# platform: macosx
# version: 55.1
# effect: php intl module (linked against icu libraries) could not be loaded
# workarounds:
# a. set env variable DYLD_LIBRARY_PATH
# b. alter install paths of icu libraries (below)

#INSTALL_NAME_DIR=$PREFIX/lib
#
#ldata=libicudata
#li18n=libicui18n
#lio=libicuio
#lle=libicule
#llx=libiculx
#ltest=libicutest
#ltu=libicutu
#luc=libicuuc
#
#sudo install_name_tool -id $INSTALL_NAME_DIR/$ldata.dylib $INSTALL_NAME_DIR/$ldata.dylib
#
#sudo install_name_tool -id $INSTALL_NAME_DIR/$li18n.dylib $INSTALL_NAME_DIR/$li18n.dylib
#sudo install_name_tool -change $ldata.55.dylib $INSTALL_NAME_DIR/$ldata.dylib $INSTALL_NAME_DIR/$li18n.dylib
#sudo install_name_tool -change $luc.55.dylib $INSTALL_NAME_DIR/$luc.dylib $INSTALL_NAME_DIR/$li18n.dylib
#
#sudo install_name_tool -id $INSTALL_NAME_DIR/$lio.dylib $INSTALL_NAME_DIR/$lio.dylib
#sudo install_name_tool -change $ldata.55.dylib $INSTALL_NAME_DIR/$ldata.dylib $INSTALL_NAME_DIR/$lio.dylib
#sudo install_name_tool -change $luc.55.dylib $INSTALL_NAME_DIR/$luc.dylib $INSTALL_NAME_DIR/$lio.dylib
#sudo install_name_tool -change $li18n.55.dylib $INSTALL_NAME_DIR/$li18n.dylib $INSTALL_NAME_DIR/$lio.dylib
#
#sudo install_name_tool -id $INSTALL_NAME_DIR/$lle.dylib $INSTALL_NAME_DIR/$lle.dylib
#sudo install_name_tool -change $ldata.55.dylib $INSTALL_NAME_DIR/$ldata.dylib $INSTALL_NAME_DIR/$lle.dylib
#sudo install_name_tool -change $luc.55.dylib $INSTALL_NAME_DIR/$luc.dylib $INSTALL_NAME_DIR/$lle.dylib
#
#sudo install_name_tool -id $INSTALL_NAME_DIR/$llx.dylib $INSTALL_NAME_DIR/$llx.dylib
#sudo install_name_tool -change $ldata.55.dylib $INSTALL_NAME_DIR/$ldata.dylib $INSTALL_NAME_DIR/$llx.dylib
#sudo install_name_tool -change $luc.55.dylib $INSTALL_NAME_DIR/$luc.dylib $INSTALL_NAME_DIR/$llx.dylib
#sudo install_name_tool -change $lle.55.dylib $INSTALL_NAME_DIR/$lle.dylib $INSTALL_NAME_DIR/$llx.dylib
#
#sudo install_name_tool -id $INSTALL_NAME_DIR/$ltest.dylib $INSTALL_NAME_DIR/$ltest.dylib
#sudo install_name_tool -change $ldata.55.dylib $INSTALL_NAME_DIR/$ldata.dylib $INSTALL_NAME_DIR/$ltest.dylib
#sudo install_name_tool -change $luc.55.dylib $INSTALL_NAME_DIR/$luc.dylib $INSTALL_NAME_DIR/$ltest.dylib
#sudo install_name_tool -change $li18n.55.dylib $INSTALL_NAME_DIR/$li18n.dylib $INSTALL_NAME_DIR/$ltest.dylib
#sudo install_name_tool -change $ltu.55.dylib $INSTALL_NAME_DIR/$ltu.dylib $INSTALL_NAME_DIR/$ltest.dylib
#
#sudo install_name_tool -id $INSTALL_NAME_DIR/$ltu.dylib $INSTALL_NAME_DIR/$ltu.dylib
#sudo install_name_tool -change $ldata.55.dylib $INSTALL_NAME_DIR/$ldata.dylib $INSTALL_NAME_DIR/$ltu.dylib
#sudo install_name_tool -change $luc.55.dylib $INSTALL_NAME_DIR/$luc.dylib $INSTALL_NAME_DIR/$ltu.dylib
#sudo install_name_tool -change $li18n.55.dylib $INSTALL_NAME_DIR/$li18n.dylib $INSTALL_NAME_DIR/$ltu.dylib
#
#sudo install_name_tool -id $INSTALL_NAME_DIR/$luc.dylib $INSTALL_NAME_DIR/$luc.dylib
#sudo install_name_tool -change $ldata.55.dylib $INSTALL_NAME_DIR/$ldata.dylib $INSTALL_NAME_DIR/$luc.dylib
