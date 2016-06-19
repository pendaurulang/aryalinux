#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:hicolor-icon-theme:0.15



cd $SOURCE_DIR

URL=http://pkgs.fedoraproject.org/repo/pkgs/hicolor-icon-theme/hicolor-icon-theme-0.15.tar.xz/md5/6aa2b3993a883d85017c7cc0cfc0fb73/hicolor-icon-theme-0.15.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.15.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.15.tar.xz || wget -nc http://pkgs.fedoraproject.org/repo/pkgs/hicolor-icon-theme/hicolor-icon-theme-0.15.tar.xz/md5/6aa2b3993a883d85017c7cc0cfc0fb73/hicolor-icon-theme-0.15.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.15.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.15.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.15.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "hicolor-icon-theme=>`date`" | sudo tee -a $INSTALLED_LIST
