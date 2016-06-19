#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:ImageMagick-6.9.3:5
#VER:urt-b:3.1
#VER:ralcgm:3.51

#REC:x7lib
#OPT:cups
#OPT:curl
#OPT:ffmpeg
#OPT:p7zip
#OPT:sane
#OPT:wget
#OPT:xdg-utils
#OPT:xterm
#OPT:gnupg
#OPT:jasper
#OPT:lcms
#OPT:lcms2
#OPT:libexif
#OPT:libjpeg
#OPT:libpng
#OPT:librsvg
#OPT:libtiff
#OPT:libwebp
#OPT:openjpeg2
#OPT:pango
#OPT:gs
#OPT:gimp
#OPT:graphviz
#OPT:inkscape
#OPT:enscript
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=ftp://ftp.imagemagick.org/pub/ImageMagick/releases/ImageMagick-6.9.3-5.tar.xz

wget -nc http://www.mcmurchy.com/ralcgm/ralcgm-3.51.tar.gz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ImageMagick/ImageMagick-6.9.3-5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ImageMagick/ImageMagick-6.9.3-5.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/ImageMagick/ImageMagick-6.9.3-5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ImageMagick/ImageMagick-6.9.3-5.tar.xz || wget -nc ftp://ftp.imagemagick.org/pub/ImageMagick/releases/ImageMagick-6.9.3-5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ImageMagick/ImageMagick-6.9.3-5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ImageMagick/ImageMagick-6.9.3-5.tar.xz
wget -nc http://www.mcmurchy.com/urt/urt-3.1b.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-hdri     \
            --with-modules    \
            --with-perl       \
            --disable-static  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make DOCUMENTATION_PATH=/usr/share/doc/imagemagick-6.9.3 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "imagemagick=>`date`" | sudo tee -a $INSTALLED_LIST
