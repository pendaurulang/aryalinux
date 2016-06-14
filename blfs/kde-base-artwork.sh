#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:kde-base-artwork:15.04.2

#REQ:kdelibs


cd $SOURCE_DIR

URL=http://download.kde.org/stable/applications/15.04.2/src/kde-base-artwork-15.04.2.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/kde-base-artwork/kde-base-artwork-15.04.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/kde-base-artwork/kde-base-artwork-15.04.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/kde-base-artwork/kde-base-artwork-15.04.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/kde-base-artwork/kde-base-artwork-15.04.2.tar.xz || wget -nc http://download.kde.org/stable/applications/15.04.2/src/kde-base-artwork-15.04.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/kde-base-artwork/kde-base-artwork-15.04.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

export KDE_PREFIX=/opt/kde


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX -Wno-dev ..



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "kde-base-artwork=>`date`" | sudo tee -a $INSTALLED_LIST

