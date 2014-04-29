#!/bin/bash
#
#==========================================
# File Name : installnginx.sh
#
# Creation Date : 08-02-2014
# Last Modified : Sun 09 Feb 2014 02:21:38 AM SAMT
# Created By : auro auro@land.ru
#==========================================
## set -ex

V=$1
ip=$2

#TB Added Port Variables
httpport=$3
httpsport=$4

test $1 || exit 1
test $2 || exit 1
test $3 || exit 1
test $4 || exit 1

function inst {
d=`dirname $0`
p=`pwd`
path=$p/$d

cd /tmp
cp $path/necessaryfiles/modsecurity-apache_2.7.7.tar.gz ./
#cp $path/necessaryfiles/nginx-1.5.10.tar.gz ./
cp $path/necessaryfiles/nginx-1.5.13.tar.gz ./
cp $path/necessaryfiles/lua-5.1.tar.gz ./
cp $path/necessaryfiles/osbf-lua-2.0.4.tar.gz ./
cp $path/necessaryfiles/v0.25.tar.gz ./
#cp $path/necessaryfiles/monit-5.7.tar.gz ./
#cp $path/necessaryfiles/AuditConsole-0.4.6-13-standalone.zip ./

apt-get update
apt-get upgrade -y
apt-get install -y gcc make apache2-prefork-dev libxml2-dev libcurl4-openssl-dev libgeoip-dev libperl-dev ncurses-dev unzip

##Added build dependancies resolve issues for nginx/modsec/apache2  - TB
apt-get -y build-dep libapache-mod-security
apt-get -y build-dep nginx apache2

tar xzf modsecurity-apache_2.7.7.tar.gz
#tar xzf nginx-1.5.10.tar.gz
tar xzf nginx-1.5.13.tar.gz
tar xzf v0.25.tar.gz
tar xzf osbf-lua-2.0.4.tar.gz
tar xzf lua-5.1.tar.gz
cd /tmp/modsecurity-apache_2.7.7
./configure --enable-standalone-module --prefix=/opt/modsecurity
make
make install
cd ./mlogc
make install

mkdir -p /opt/modsecurity/etc/conf/
cp $path/necessaryfiles/login.conf /opt/modsecurity/etc/conf/

#throw in CRS
mkdir -p /opt/modsecurity/etc/crs
#cd /tmp
#tar xzf SpiderLabs-owasp-modsecurity-crs-2.2.8-8-g7528b8b.tar.gz
cp -r $path/necessaryfiles/crs/* /opt/modsecurity/etc/crs/

cd /tmp/nginx-1.5.13
./configure --prefix=/opt/nginx$V/nginx --conf-path=/opt/nginx$V/etc/nginx.conf --sbin-path=/opt/nginx$V/sbin/nginx --error-log-path=/opt/nginx$V/log/error.log --http-client-body-temp-path=/opt/nginx$V/lib/body --http-fastcgi-temp-path=/opt/nginx$V/lib/fastcgi --http-log-path=/opt/nginx$V/log/access.log --http-proxy-temp-path=/opt/nginx$V/lib/proxy --http-scgi-temp-path=/opt/nginx$V/lib/scgi --http-uwsgi-temp-path=/opt/nginx$V/lib/uwsgi --lock-path=/opt/nginx$V/lock/nginx.lock --pid-path=/opt/nginx$V/run/nginx.pid --with-http_geoip_module --with-http_stub_status_module --with-http_ssl_module --with-ipv6 --with-http_perl_module --add-module=../modsecurity-apache_2.7.7/nginx/modsecurity/ --add-module=../headers-more-nginx-module-0.25

make
make install
mkdir -p /opt/nginx$V/lib/body

## Build Lua OSBF-Lua
cd /tmp/lua-5.1
make linux
make install
cd /tmp/osbf-lua-2.0.4
cp $path/necessaryfiles/osbf_bayes.c ./
make
make install
cp $path/necessaryfiles/moonrunner.lua /opt/modsecurity/etc/crs/lua/ && cp $path/necessaryfiles/moonrunner.lua /usr/local/share/lua/5.1/
cp $path/necessaryfiles/moonfilter.lua /opt/modsecurity/etc/crs/lua/ && cp $path/necessaryfiles/moonfilter.lua /usr/local/share/lua/5.1/
cp $path/necessaryfiles/scripts/moonrunner_init.sh /opt/modsecurity/etc/crs/lua/
mkdir -p /var/log/httpd/

## Build Monit
#cd /tmp
#tar xzf monit-5.7.tar.gz
#cd monit-5.7
#./configure
#make
#make install

# Install Arachni
cp $path/necessaryfiles/arachni-0.4.7-0.4.4-linux-x86_64.tar.gz /opt
cd /opt
tar xzf arachni-0.4.7-0.4.4-linux-x86_64.tar.gz
rm arachni-0.4.7-0.4.4-linux-x86_64.tar.gz

# install monit
dpkg -i $path/necessaryfiles/monit_5.5.1-1_amd64.deb
## Build and Install AuditConsole
#apt-get install -y openjdk-6-jre openjdk-6-jdk unzip
#	cd /opt
#	cp $path/necessaryfiles/AuditConsole-0.4.6-13-standalone.zip ./
#	unzip AuditConsole-0.4.6-13-standalone.zip
#	cd AuditConsole
#	chmod 755 bin/*.sh
#	sh bin/catalina.sh start
	cp /$path/necessaryfiles/mlogc.conf /opt/modsecurity/etc/conf/mlogc.conf
#	useradd tomcat6
#	chown tomcat6 /opt/AuditConsole/
## Copy init.d script for nginx

## Install Tomcat7 and setup AuditConsole
apt-get install -y tomcat7
mkdir -p /var/lib/tomcat7/logs
cp $path/necessaryfiles/AuditConsole.war /var/lib/tomcat7/webapps
service tomcat7 restart

cp $path/necessaryfiles/nginx /etc/init.d/

sed -i 's#DAEMON=.*#DAEMON=/opt/nginx'$V'/sbin/nginx#g
s#PIDSPATH=.*#PIDSPATH=/opt/nginx'$V'/run/#g
s#lockfile=.*#lockfile=/opt/nginx'$V'/lock/nginx.lock#g
s#NGINX_CONF_FILE=.*#NGINX_CONF_FILE=/opt/nginx'$V'/etc/nginx.conf#g' /etc/init.d/nginx
chmod +x /etc/init.d/nginx

#Make Necessary Directories for Modsecurity
#mkdir /opt/modsecurity/logs/

mkdir /opt/modsecurity/rule_scripts/
mkdir /opt/modsecurity/persistent/
mkdir /opt/modsecurity/upload/
mkdir -p /var/log/shield/audit/

chown -R www-data: /opt/modsecurity/persistent
#chown -R www-data: /opt/modsecurity/logs
chown -R www-data: /var/log/shield
chown -R www-data: /opt/modsecurity/upload

cp $path/necessaryfiles/includedrules.conf /opt/modsecurity/etc/conf/
cp $path/necessaryfiles/GeoLiteCity.dat /opt/modsecurity/lib/
cp /tmp/modsecurity-apache_2.7.7/unicode.mapping /opt/modsecurity/etc/conf/

# Setup scripting directory
mkdir -p /var/www/scripts/
cp $path/necessaryfiles/scripts/* /var/www/scripts/
update-rc.d -f nginx defaults

cp $path/necessaryfiles/nginx.conf /opt/nginx$V/etc/
sed -i 's/IPADDR/'$ip'/g' /opt/nginx$V/etc/nginx.conf

#TB added ports
sed -i 's/HTTPP/'$httpport'/g' /opt/nginx$V/etc/nginx.conf
sed -i 's/HTTPSP/'$httpsport'/g' /opt/nginx$V/etc/nginx.conf

# add certificates
mkdir -p /home/certs
cp $path/necessaryfiles/myserver.* /home/certs/

# Setting path and global variables to BASH
cp $path/necessaryfiles/bash.bashrc /etc/

service nginx start

}

inst 2>&1 | tee /var/log/installnginx.log
