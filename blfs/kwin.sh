#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:kwin:5.3.1

#REQ:kdecoration
#REQ:kf5
#OPT:kwayland
#OPT:libinput
#OPT:mesa


cd $SOURCE_DIR

URL=http://download.kde.org/stable/plasma/5.3.1/kwin-5.3.1.tar.xz

wget -nc http://download.kde.org/stable/plasma/5.3.1/kwin-5.3.1.tar.xz || wget -nc ftp://ftp.kde.org/pub/kde/stable/plasma/5.3.1/kwin-5.3.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -DQML_INSTALL_DIR=lib/qt5/qml           \
      -DQT_PLUGIN_INSTALL_DIR=lib/qt5/plugins \
      .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "kwin=>`date`" | sudo tee -a $INSTALLED_LIST

