#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mesa:12.0.1

#REQ:x7lib
#REQ:libdrm
#REQ:python2
#REC:elfutils
#REC:x7driver
#REC:x7driver#libvdpau
#REC:llvm
#OPT:libgcrypt
#OPT:nettle
#OPT:wayland
#OPT:plasma-all


cd $SOURCE_DIR

URL=ftp://ftp.freedesktop.org/pub/mesa/12.0.1/mesa-12.0.1.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz || wget -nc ftp://ftp.freedesktop.org/pub/mesa/12.0.1/mesa-12.0.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/downloads/mesa/mesa-12.0.1-add_xdemos-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/7.10/mesa-12.0.1-add_xdemos-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

patch -Np1 -i ../mesa-12.0.1-add_xdemos-1.patch


GLL_DRV="nouveau,r300,r600,radeonsi,svga,swrast,swr" &&
sed -i "/pthread-stubs/d" configure.ac      &&
sed -i "/seems to be moved/s/^/: #/" bin/ltmain.sh &&
./autogen.sh CFLAGS='-O2' CXXFLAGS='-O2'    \
            --prefix=$XORG_PREFIX           \
            --sysconfdir=/etc               \
            --enable-texture-float          \
            --enable-gles1                  \
            --enable-gles2                  \
            --enable-osmesa                 \
            --enable-xa                     \
            --enable-gbm                    \
            --enable-glx-tls                \
            --with-egl-platforms="drm,x11"  \
            --with-gallium-drivers=$GLL_DRV &&
unset GLL_DRV &&
make "-j`nproc`"


make -C xdemos DEMOS_PREFIX=$XORG_PREFIX



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C xdemos DEMOS_PREFIX=$XORG_PREFIX install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/mesa-12.0.1 &&
cp -rfv docs/* /usr/share/doc/mesa-12.0.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mesa=>`date`" | sudo tee -a $INSTALLED_LIST

