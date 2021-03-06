#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Apache Ant package is abr3ak Java-based build tool. In theory,br3ak it is like the <span class=\"command\"><strong>make</strong>br3ak command, but without <span class=\"command\"><strong>make</strong>'s wrinkles. Ant is different. Instead of a model that isbr3ak extended with shell-based commands, Ant is extended using Java classes. Instead of writing shellbr3ak commands, the configuration files are XML-based, calling out abr3ak target tree that executes various tasks. Each task is run by anbr3ak object that implements a particular task interface.br3ak"
SECTION="general"
VERSION=1.9.7
NAME="apache-ant"

#REQ:glib2
#REQ:java8


cd $SOURCE_DIR

URL=https://archive.apache.org/dist/ant/source/apache-ant-1.9.7-src.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/apache-ant/apache-ant-1.9.7-src.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/apache-ant/apache-ant-1.9.7-src.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/apache-ant/apache-ant-1.9.7-src.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/apache-ant/apache-ant-1.9.7-src.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/apache-ant/apache-ant-1.9.7-src.tar.bz2 || wget -nc https://archive.apache.org/dist/ant/source/apache-ant-1.9.7-src.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/apache-ant/apache-ant-1.9.7-src.tar.bz2

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

cp -v ../junit-4.11.jar \
      ../hamcrest-core-1.3.jar lib/optional



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
./build.sh -Ddist.dir=/opt/ant-1.9.7 dist &&
ln -v -sfn ant-1.9.7 /opt/ant

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/ant.sh << EOF
# Begin /etc/profile.d/ant.sh
pathappend /opt/ant/bin
export ANT_HOME=/opt/ant
# End /etc/profile.d/ant.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
