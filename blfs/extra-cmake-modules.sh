#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:extra-cmake-modules:5.18.0

#REQ:cmake


cd $SOURCE_DIR

URL=http://download.kde.org/stable/frameworks/5.18/extra-cmake-modules-5.18.0.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/extra-cmake-modules/extra-cmake-modules-5.18.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/extra-cmake-modules/extra-cmake-modules-5.18.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/extra-cmake-modules/extra-cmake-modules-5.18.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/extra-cmake-modules/extra-cmake-modules-5.18.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/extra-cmake-modules/extra-cmake-modules-5.18.0.tar.xz || wget -nc http://download.kde.org/stable/frameworks/5.18/extra-cmake-modules-5.18.0.tar.xz || wget -nc ftp://ftp.kde.org/pub/kde/stable/frameworks/5.18//extra-cmake-modules-5.18.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "extra-cmake-modules=>`date`" | sudo tee -a $INSTALLED_LIST
