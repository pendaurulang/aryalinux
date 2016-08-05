#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:glew_.orig:1.13.0

URL=http://archive.ubuntu.com/ubuntu/pool/main/g/glew/glew_1.13.0.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "libglew=>`date`" | sudo tee -a $INSTALLED_LIST