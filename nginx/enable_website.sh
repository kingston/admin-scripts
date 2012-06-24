#!/bin/bash

# NAME: Enable Website
# DESCRIPTION: Enables a web site configuration
# NOTES: This is not a generalizable script.  It relies on certain files being there and is just for personal use.  Play with it how you will.

# Expectations
# + sites-available/ and sites-enabled/ directories in conf directory

EXPECTED_ARGS=1
E_BADARGS=65

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi

if [ $# -ne $EXPECTED_ARGS ]; then
    echo "Usage: $0 domain"
    exit $E_BADARGS
fi

# Configuration

CONFIG_FILE=`dirname $0`/nginx.cfg
if [ ! -f $CONFIG_FILE ]; then
    echo "Unable to find nginx.cfg configuration file.  Goodbye!"
    exit 1
fi

source $CONFIG_FILE

# Copy template and replace

echo "Enabling website..."

DOMAIN=$1
SOURCE_FILE=$NGINX_CONF/sites-available/$DOMAIN
TARGET_FILE=$NGINX_CONF/sites-enabled/$DOMAIN

if [ ! -f $SOURCE_FILE ]; then
    echo "Unable to find source file - $SOURCE_FILE!  Goodbye"
    exit 1
fi

ln -s $SOURCE_FILE $TARGET_FILE

echo "Site succesfully enabled!"

read -p "Restart nginx (y/n)? "

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
fi

/etc/init.d/nginx restart

