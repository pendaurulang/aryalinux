#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/openjdk.sh << "EOF"
# Begin /etc/profile.d/openjdk.sh
# Set JAVA_HOME directory
JAVA_HOME=/opt/jdk
# Adjust PATH
pathappend $JAVA_HOME/bin
# Add to MANPATH
pathappend $JAVA_HOME/man MANPATH
# Auto Java CLASSPATH: Copy jar files to, or create symlinks in, the
# /usr/share/java directory. Note that having gcj jars with OpenJDK 8
# may lead to errors.
AUTO_CLASSPATH_DIR=/usr/share/java
pathprepend . CLASSPATH
for dir in `find ${AUTO_CLASSPATH_DIR} -type d 2>/dev/null`; do
 pathappend $dir CLASSPATH
done
for jar in `find ${AUTO_CLASSPATH_DIR} -name "*.jar" 2>/dev/null`; do
 pathappend $jar CLASSPATH
done
export JAVA_HOME
unset AUTO_CLASSPATH_DIR dir jar
# End /etc/profile.d/openjdk.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/man_db.conf << "EOF" &&
# Begin Java addition
MANDATORY_MANPATH /opt/jdk/man
MANPATH_MAP /opt/jdk/bin /opt/jdk/man
MANDB_MAP /opt/jdk/man /var/cache/man/jdk
# End Java addition
EOF
mkdir -p /var/cache/man
mandb -c /opt/jdk/man

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "ojdk-conf=>`date`" | sudo tee -a $INSTALLED_LIST

