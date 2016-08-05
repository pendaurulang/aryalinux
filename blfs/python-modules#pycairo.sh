#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pycairo:1.10.0

#REQ:cairo
#REQ:python3


cd $SOURCE_DIR

URL=http://cairographics.org/releases/pycairo-1.10.0.tar.bz2

wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/pycairo-1.10.0-waf_unpack-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/pycairo/pycairo-1.10.0-waf_unpack-1.patch
wget -nc http://cairographics.org/releases/pycairo-1.10.0.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/downloads/pycairo/pycairo-1.10.0-waf_python_3_4-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/pycairo-1.10.0-waf_python_3_4-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../pycairo-1.10.0-waf_unpack-1.patch     &&
wafdir=$(./waf unpack) &&
pushd $wafdir          &&
patch -Np1 -i ../../pycairo-1.10.0-waf_python_3_4-1.patch &&
popd                   &&
unset wafdir           &&
PYTHON=/usr/bin/python3 ./waf configure --prefix=/usr  &&
./waf build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
./waf install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "python-modules#pycairo=>`date`" | sudo tee -a $INSTALLED_LIST
