#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak AbiWord is a word processor whichbr3ak is useful for writing reports, letters and other formattedbr3ak documents.br3ak"
SECTION="xsoft"
VERSION=3.0.1
NAME="AbiWord"

#REQ:boost
#REQ:fribidi
#REQ:goffice010
#REQ:wv
#REC:enchant
#OPT:dbus-glib
#OPT:gobject-introspection
#OPT:libgcrypt
#OPT:libical
#OPT:libsoup
#OPT:redland
#OPT:valgrind
#OPT:evolution-data-server
#OPT:libchamplain
#OPT:telepathy-glib


cd $SOURCE_DIR

URL=http://www.abisource.com/downloads/abiword/3.0.1/source/abiword-3.0.1.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/abiword/abiword-3.0.1.tar.gz || wget -nc http://www.abisource.com/downloads/abiword/3.0.1/source/abiword-3.0.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/abiword/abiword-3.0.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/abiword/abiword-3.0.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/abiword/abiword-3.0.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/abiword/abiword-3.0.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/abiword/abiword-3.0.1.tar.gz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/abiword/abiword-docs-3.0.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/abiword/abiword-docs-3.0.1.tar.gz || wget -nc http://www.abisource.com/downloads/abiword/3.0.1/source/abiword-docs-3.0.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/abiword/abiword-docs-3.0.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/abiword/abiword-docs-3.0.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/abiword/abiword-docs-3.0.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/abiword/abiword-docs-3.0.1.tar.gz

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


tar -xf ../abiword-docs-3.0.1.tar.gz &&
cd abiword-docs-3.0.1                &&
./configure --prefix=/usr            &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


ls /usr/share/abiword-3.0/templates


install -v -m750 -d ~/.AbiSuite/templates &&
install -v -m640    /usr/share/abiword-3.0/templates/normal.awt-<em class="replaceable"><code><lang></em> \
                    ~/.AbiSuite/templates/normal.awt




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
