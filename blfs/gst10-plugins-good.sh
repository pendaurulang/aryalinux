#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gst-plugins-good:1.6.3

#REQ:gst10-plugins-base
#REC:cairo
#REC:flac
#REC:gdk-pixbuf
#REC:libjpeg
#REC:libpng
#REC:libsoup
#REC:libvpx
#REC:x7lib
#OPT:aalib
#OPT:gtk3
#OPT:gtk-doc
#OPT:libdv
#OPT:libgudev
#OPT:pulseaudio
#OPT:speex
#OPT:taglib
#OPT:valgrind
#OPT:v4l-utils


cd $SOURCE_DIR

URL=http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.6.3.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.6.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.6.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.6.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.6.3.tar.xz || wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.6.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.6.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e '/smgradio/ {
    a \  \/* Radionomy Hot40Music shoutcast stream *\/
    a \  g_object_set (src, "location",
    a \      "http://streaming.radionomy.com:80/Hot40Music", NULL);
  }'  \
    -e '/Virgin/,/smgradio/d' \
    -i tests/check/elements/souphttpsrc.c &&
./configure --prefix=/usr \
            --with-package-name="GStreamer Good Plugins 1.6.3 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/"  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gst10-plugins-good=>`date`" | sudo tee -a $INSTALLED_LIST
