#!/bin/bash

. `dirname $0`/env.sh
import 'out'


readonly URI='https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.bz2'
readonly DEST='/opt/lib/boost'

cachegetfile "$URI" 'regdest'

readonly ICUDIR='/opt/lib/icu4c'
readonly PYTHONDIR='/opt/python36'

pushd "$regdest" >/dev/null||exit 1
./bootstrap.sh \
--prefix="$DEST" \
--with-libraries=\
filesystem\
,program_options\
,system\
,locale\
,math\
,python \
--with-icu="$ICUDIR" \
--with-python="$PYTHONDIR/bin/python3.6" \
&& ./b2 -j2 -a > ./build.log 2>&1 \
&& sudo ./b2 install \
&& ./b2 --clean
popd >/dev/null


