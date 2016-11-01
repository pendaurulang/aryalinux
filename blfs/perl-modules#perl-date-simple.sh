#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


SOURCE_ONLY=y
URL="http://www.cpan.org/authors/id/I/IZ/IZUT/Date-Simple-3.03.tar.gz"
NAME="perl-modules#perl-date-simple"
VERSION=3.03

cd $SOURCE_DIR
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

if [ -f Build.PL ]
then
perl Build.PL &&
./Build &&
sudo ./Build install
fi

if [ -f Makefile.PL ]
then
perl Makefile.PL &&
make &&
sudo make install
fi
cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

echo "perl-modules#perl-date-simple=>`date`" | sudo tee -a $INSTALLED_LIST

