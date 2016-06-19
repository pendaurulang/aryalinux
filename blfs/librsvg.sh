#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:librsvg:2.40.13

#REQ:gdk-pixbuf
#REQ:libcroco
#REQ:pango
#REC:gobject-introspection
#REC:gtk3
#REC:vala
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/librsvg/2.40/librsvg-2.40.13.tar.xz

wget -nc http://ftp.gnome.org/pub/gnome/sources/librsvg/2.40/librsvg-2.40.13.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/librsvg/librsvg-2.40.13.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/librsvg/librsvg-2.40.13.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/librsvg/librsvg-2.40.13.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/librsvg/librsvg-2.40.13.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/librsvg/2.40/librsvg-2.40.13.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/librsvg/librsvg-2.40.13.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --enable-vala    \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "librsvg=>`date`" | sudo tee -a $INSTALLED_LIST
