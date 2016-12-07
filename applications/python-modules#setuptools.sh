#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="general"
VERSION=30.2.0
NAME="python-modules#setuptools"

#REQ:python2
#REQ:python3


cd $SOURCE_DIR

URL=https://pypi.python.org/packages/f1/92/12c7251039b274c30106c3e0babdcb040cbd13c3ad4b3f0ef9a7c217e36a/setuptools-30.2.0.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/setuptools/setuptools-30.2.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/setuptools/setuptools-30.2.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/setuptools/setuptools-30.2.0.tar.gz || wget -nc https://pypi.python.org/packages/f1/92/12c7251039b274c30106c3e0babdcb040cbd13c3ad4b3f0ef9a7c217e36a/setuptools-30.2.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/setuptools/setuptools-30.2.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/setuptools/setuptools-30.2.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/setuptools/setuptools-30.2.0.tar.gz

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python3 setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
