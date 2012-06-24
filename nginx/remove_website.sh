#!/bin/bash

# NAME: Remove Website
# DESCRIPTION: Removes a website from the nginx roster
# NOTES: This is not a generalizable script.  It relies on certain files being there and is just for personal use.  Play with it how you will.
# NOTES2: It will also not remove the actual webapps folder

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

# Ask for confirmation

DOMAIN=$1
TARGET_FILE=$NGINX_CONF/sites-available/$DOMAIN

read -p "Are you sure you want to delete $DOMAIN (y/n)? "

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Copy template and replace

echo "Deleting website configuration..."
echo

if [ ! -f $TARGET_FILE ]; then
    echo "Unable to find $TARGET_FILE.  Goodbye!"
    exit 1
fi

`dirname $0`/disable_website.sh $DOMAIN

rm -f $TARGET_FILE

# We're done!

echo "Website at $DOMAIN successfully deleted!"
echo "Please note that the web directory folder and logs remains"

read -p "Restart nginx (y/n)? "

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
fi

/etc/init.d/nginx restart

