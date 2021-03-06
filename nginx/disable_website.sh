#!/bin/bash

# NAME: Disable Website
# DESCRIPTION: Disables a web site configuration
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

echo "Disabling website..."

DOMAIN=$1
TARGET_FILE=$NGINX_CONF/sites-enabled/$DOMAIN

if [ ! -f $TARGET_FILE ]; then
    echo "Unable to find target file - $TARGET_FILE!  Goodbye"
    exit 1
fi

rm -f $TARGET_FILE

echo "Website succesfully disabled!"

read -p "Restart nginx (y/n)? "

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
fi

/etc/init.d/nginx restart
