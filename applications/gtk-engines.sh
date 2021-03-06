#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GTK Engines package containsbr3ak eight themes/engines and two additional engines for GTK2.br3ak"
SECTION="x"
VERSION=2.20.2
NAME="gtk-engines"

#REQ:gtk2
#OPT:lua
#OPT:general_which


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtk-engines/2.20/gtk-engines-2.20.2.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk-engines/gtk-engines-2.20.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-engines/gtk-engines-2.20.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gtk-engines/gtk-engines-2.20.2.tar.bz2 || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-engines/2.20/gtk-engines-2.20.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk-engines/gtk-engines-2.20.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk-engines/gtk-engines-2.20.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-engines/gtk-engines-2.20.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
