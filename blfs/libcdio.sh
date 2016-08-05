#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libcdio-paranoia:10.2+0.93+1
#VER:libcdio:0.93

#OPT:libcddb


cd $SOURCE_DIR

URL=http://ftp.gnu.org/gnu/libcdio/libcdio-0.93.tar.bz2

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcdio-paranoia/libcdio-paranoia-10.2+0.93+1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcdio-paranoia/libcdio-paranoia-10.2+0.93+1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcdio-paranoia/libcdio-paranoia-10.2+0.93+1.tar.bz2 || wget -nc http://ftp.gnu.org/gnu/libcdio/libcdio-paranoia-10.2+0.93+1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcdio-paranoia/libcdio-paranoia-10.2+0.93+1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcdio-paranoia/libcdio-paranoia-10.2+0.93+1.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcdio/libcdio-0.93.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcdio/libcdio-0.93.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcdio/libcdio-0.93.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcdio/libcdio-0.93.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcdio/libcdio-0.93.tar.bz2 || wget -nc http://ftp.gnu.org/gnu/libcdio/libcdio-0.93.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../libcdio-paranoia-10.2+0.93+1.tar.bz2 &&
cd libcdio-paranoia-10.2+0.93+1
./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libcdio=>`date`" | sudo tee -a $INSTALLED_LIST
