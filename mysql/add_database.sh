#!/bin/bash
# NAME: Add MySQL Database
# DESCRIPTION: Adds a new MySQL database with the specified name and creates a new user with a random password
# NOTE: Currently configured to set up account such that it is only accessible by localhost

EXPECTED_ARGS=2
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]; then
    echo "Usage: $0 database_name database_user"
    exit $E_BADARGS
fi

# Configuration
. `dirname $0`/../shared.sh

load_config `dirname $0`/mysql.cfg

# Get password

read -s -p "Enter database user password (leave blank for random): " USER_PASSWORD

if [ "$USER_PASSWORD" == "" ]; then
    generate_random_password
    USER_PASSWORD=$PASSWORD
fi

echo ""

if [ "$MYSQL_PASSWORD" == "" ]; then
    read -s -p "Enter MySQL password for user $MYSQL_USER: " MYSQL_PASSWORD
fi

echo ""

# Check for existing database

DB_OUTPUT=`mysql --batch -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES LIKE '$1'" | grep $1`

if [ "$DB_OUTPUT" != "" ]; then
    echo "Existing $1 database found.  Please remove before proceeding."
    exit 1
fi

# Create database

mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE $1; GRANT ALL PRIVILEGES ON $1.* TO '$2'@'localhost' IDENTIFIED BY '$USER_PASSWORD';"

if [ "$?" -ne 0 ]; then
    echo "Error creating database!"
    exit 1
fi

echo ""

echo "Database successfully created!"
echo "Database Name: $1"
echo "Database User: $2"
echo "Database Password: $USER_PASSWORD"

