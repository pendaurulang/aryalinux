#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:transmission:2.84

#REQ:curl
#REQ:libevent
#REQ:openssl
#REC:gtk3
#OPT:doxygen
#OPT:gdb


cd $SOURCE_DIR

URL=https://transmission.cachefly.net/transmission-2.84.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/transmission/transmission-2.84.tar.xz || wget -nc https://transmission.cachefly.net/transmission-2.84.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/transmission/transmission-2.84.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/transmission/transmission-2.84.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/transmission/transmission-2.84.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/transmission/transmission-2.84.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"


sed -i '/^CONFIG/aQMAKE_CXXFLAGS += -std=c++11' qt/qtr.pro



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "transmission=>`date`" | sudo tee -a $INSTALLED_LIST

