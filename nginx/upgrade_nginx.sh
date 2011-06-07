#!/bin/bash

# NAME: nginx Upgrade Script
# DESCRIPTION: Upgrades nginx with Phusion Passenger and custom options

# CONFIGURATION:

NGINX_DIR=/opt/nginx

# Boilerplate...

EXPECTED_ARGS=1
E_BADARGS=65

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi

if [ $# -ne $EXPECTED_ARGS ]; then
    echo Usage: $0 version
    exit $E_BADARGS
fi

# Ask for confirmation

read -p "Are you sure you want to upgrade nginx (y/n)? "

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Download nginx source code

wget -O nginx.tar.gz http://nginx.org/download/nginx-$1.tar.gz

if [ $? -ne 0 ]; then
    rm -f nginx.tar.gz
    echo "Error downloading nginx distributable, incorrect version?"
    exit 1
fi

tar xzf nginx.tar.gz

rm -f nginx.tar.gz

mv nginx-$1 nginx_source

# Let's back up stuff

cp $NGINX_DIR/conf/nginx.conf $NGINX_DIR/conf/nginx.conf.bak
cp -r $NGINX_DIR/conf/sites-available $NGINX_DIR/conf/sites-available-bak

# Now execute passenger

echo "Executing Passenger Phusion..."

echo "Source code is in `pwd`/nginx_source"
echo "And use the following configure lines:"
echo "--with-http_ssl_module --add-module=`pwd`/[upload_module_path]"

passenger-install-nginx-module

echo "Done!"
echo "Be sure to update the nginx.conf"

read -p "Restart nginx (y/n)? "

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
fi

$NGINX_DIR/sbin/nginx -t -c $NGINX_DIR/conf/nginx.conf

/etc/init.d/nginx restart
