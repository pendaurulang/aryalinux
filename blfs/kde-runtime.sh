#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:kde-runtime:15.04.2

#REQ:kdelibs
#REQ:libgcrypt
#REC:alsa-lib
#REC:exiv2
#REC:kactivities
#REC:kdepimlibs
#OPT:libcanberra
#OPT:networkmanager
#OPT:pulseaudio
#OPT:samba
#OPT:xine-lib


cd $SOURCE_DIR

URL=http://download.kde.org/stable/applications/15.04.2/src/kde-runtime-15.04.2.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/kde/kde-runtime-15.04.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/kde/kde-runtime-15.04.2.tar.xz || wget -nc http://download.kde.org/stable/applications/15.04.2/src/kde-runtime-15.04.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/kde/kde-runtime-15.04.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/kde/kde-runtime-15.04.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/kde/kde-runtime-15.04.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export KDE_PREFIX=/opt/kde


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX         \
      -DSYSCONF_INSTALL_DIR=/etc                 \
      -DCMAKE_BUILD_TYPE=Release                 \
      -DSAMBA_INCLUDE_DIR=/usr/include/samba-4.0 \
      -Wno-dev .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -sfv ../lib/kde4/libexec/kdesu $KDE_PREFIX/bin/kdesu

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "kde-runtime=>`date`" | sudo tee -a $INSTALLED_LIST
