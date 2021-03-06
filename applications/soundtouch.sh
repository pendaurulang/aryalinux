#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The SoundTouch package contains anbr3ak open-source audio processing library that allows changing the soundbr3ak tempo, pitch and playback rate parameters independently from eachbr3ak other.br3ak"
SECTION="multimedia"
VERSION=1.9.2
NAME="soundtouch"



cd $SOURCE_DIR

URL=http://www.surina.net/soundtouch/soundtouch-1.9.2.tar.gz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/soundtouch/soundtouch-1.9.2.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/soundtouch/soundtouch-1.9.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/soundtouch/soundtouch-1.9.2.tar.gz || wget -nc http://www.surina.net/soundtouch/soundtouch-1.9.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/soundtouch/soundtouch-1.9.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/soundtouch/soundtouch-1.9.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/soundtouch/soundtouch-1.9.2.tar.gz

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

./bootstrap &&
./configure --prefix=/usr \
            --docdir=/usr/share/doc/soundtouch-1.9.2 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
