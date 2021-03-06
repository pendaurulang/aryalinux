#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-modules#perl-module-implementation
#REQ:perl-modules#list-utilsby
#REQ:perl-modules#number-compare
#REQ:perl-modules#scalar-list-utils
#REQ:perl-modules#perl-test-warnings
#REQ:perl-modules#text-glob

SOURCE_ONLY=y
URL="http://www.cpan.org/authors/id/D/DR/DROLSKY/List-AllUtils-0.12.tar.gz"
VERSION=0.12
NAME="perl-modules#perl-list-allutils"

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

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME=>`date`" "$VERSION" "$INSTALLED_LIST"
