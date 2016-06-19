#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:time:1.7



cd $SOURCE_DIR

URL=http://ftp.gnu.org/gnu/time/time-1.7.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/time/time-1.7.tar.gz || wget -nc http://ftp.gnu.org/gnu/time/time-1.7.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/time/time-1.7.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/time/time-1.7.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/time/time-1.7.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/time/time-1.7.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/time/time-1.7.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's/$(ACLOCAL)//' Makefile.in                                            &&
sed -i 's/lu", ptok ((UL) resp->ru.ru_maxrss)/ld", resp->ru.ru_maxrss/' time.c &&
./configure --prefix=/usr --infodir=/usr/share/info                            &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "time=>`date`" | sudo tee -a $INSTALLED_LIST
