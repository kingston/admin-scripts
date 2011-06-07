#!/bin/bash

# NAME: Add Website
# DESCRIPTION: Creates a web site configuration and sets up the folder structure
# NOTES: This is not a generalizable script.  It relies on certain files being there and is just for personal use.  Play with it how you will.

# Expectations
# + sites-available/ and sites-enabled/ directories in conf directory
# + sites-available/php-template, sites-available/rails-template, sites-available/static-template
#   -  These templates will have {user}, {domain}, {appname} replaced
# + /home/USER/webapps/APPNAME structure for storing web apps

EXPECTED_ARGS=4
E_BADARGS=65

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi

if [ $# -ne $EXPECTED_ARGS ]; then
    echo "Usage: $0 user domain appname type"
    echo "Possible types: php, rails, static"
    exit $E_BADARGS
fi

# Configuration

if [ ! -f ./nginx.cfg ]; then
    echo "Unable to find nginx.cfg configuration file.  Goodbye!"
    exit 1
fi

source nginx.cfg

# Copy template and replace

echo "Creating website configuration..."
echo

USER=$1
DOMAIN=$2
APPNAME=$3
TYPE=$4
TEMPLATE_FILE=$NGINX_CONF/sites-available/$TYPE-template
TARGET_FILE=$NGINX_CONF/sites-available/$DOMAIN

if [ ! -f $TEMPLATE_FILE ]; then
    echo "Unable to find template file - $TEMPLATE_FILE!  Goodbye"
    exit 1
fi

cp $TEMPLATE_FILE $TARGET_FILE
sed -i "s/{USER}/$USER/g" $TARGET_FILE
sed -i "s/{DOMAIN}/$DOMAIN/g" $TARGET_FILE
sed -i "s/{APPNAME}/$APPNAME/g" $TARGET_FILE

# Create directory structure

echo "Creating skeleton website structure..."
echo

TARGET_DIR=/home/$USER/webapps/$APPNAME

mkdir $TARGET_DIR
chown -R $USER:$USER $TARGET_DIR

# We're done!

echo "Website at $DOMAIN successfully created at $TARGET_DIR!"
echo "Just enable the site and restart nginx to finish it off"

