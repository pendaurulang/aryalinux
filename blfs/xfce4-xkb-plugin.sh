#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xfce4-xkb-plugin:0.7.1

#REQ:librsvg
#REQ:libxklavier
#REQ:xfce4-panel


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/panel-plugins/xfce4-xkb-plugin/0.7/xfce4-xkb-plugin-0.7.1.tar.bz2

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-xkb-plugin-0.7.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-xkb-plugin-0.7.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-xkb-plugin-0.7.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-xkb-plugin-0.7.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfce/xfce4-xkb-plugin-0.7.1.tar.bz2 || wget -nc http://archive.xfce.org/src/panel-plugins/xfce4-xkb-plugin/0.7/xfce4-xkb-plugin-0.7.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

sed -e 's|xfce4/panel-plugins|xfce4/panel/plugins|' \
    -i panel-plugin/{Makefile.in,xkb-plugin.desktop.in.in} &&
./configure --prefix=/usr         \
            --libexecdir=/usr/lib \
            --disable-debug       &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xfce4-xkb-plugin=>`date`" | sudo tee -a $INSTALLED_LIST

