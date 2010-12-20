#!/bin/bash

# Settings
DAYS_TO_KEEP=7 # The number of days to keep in daily backups
WEEKS_TO_KEEP=7 # The number of weeks to keep in weekly backups
DIR_FORMAT="%Y-%m-%d" # YYYY-MM-DD format
ORIGIN_DIR=~/webapps/myapp #Source directory
DEST_DIR=~/backups/production #Destination directory
WEEKLY_DAY=0 #When to run weekly backups (0 = Sunday, ..., 6 = Saturday)

SQL_DATABASE=my_database
SQL_USERNAME=root
SQL_PASSWORD=

# Pre-init checks
echo "Backing up files..."

if [ ! -d "${DEST_DIR}" ]; then
    mkdir "${DEST_DIR}"
fi

if [ ! -d "${DEST_DIR}/daily" ]; then
    mkdir ${DEST_DIR}/daily
fi

if [ ! -d "${DEST_DIR}/weekly" ]; then
    mkdir ${DEST_DIR}/weekly
fi

# Clean up backups

# Daily Backups
find ${DEST_DIR}/daily/ -mindepth 1 -maxdepth 1 -type d -mtime +${DAYS_TO_KEEP} -exec echo "Removing Directory => {}" \; -exec chmod 777 -R "{}" \; -exec rm -rf "{}" \;
# Weekly Backups
DAY_NUMBER=`expr ${WEEKS_TO_KEEP} \* 7`
find ${DEST_DIR}/weekly/ -mindepth 1 -maxdepth 1 -type d -mtime +${DAY_NUMBER} -exec echo "Removing Directory => {}" \; -exec chmod 777 -R "{}" \; -exec rm -rf "{}" \;

# Run backup

# Backup database

DAILY_DESTINATION=${DEST_DIR}/daily/`date +"$DIR_FORMAT"`
if [ ! -d "${DAILY_DESTINATION}" ]; then
  echo Performing daily backup...
  cp -r ${ORIGIN_DIR} ${DAILY_DESTINATION}
  mysqldump -u${SQL_USERNAME} -p${SQL_PASSWORD} ${SQL_DATABASE} > ${DAILY_DESTINATION}/dump.sql
  echo Copied files from ${ORIGIN_DIR} to ${DAILY_DESTINATION}
fi

if [ `date +%w` -eq ${WEEKLY_DAY} ]; then
  WEEKLY_DESTINATION=${DEST_DIR}/weekly/`date +"$DIR_FORMAT"`
  if [ ! -d "${WEEKLY_DESTINATION}" ]; then
    echo Performing weekly backup...
    cp -r ${DAILY_DESTINATION} ${WEEKLY_DESTINATION}
    echo Copied files from ${DAILY_DESTINATION} to ${WEEKLY_DESTINATION}
  fi
fi

echo "Backup complete!"
echo ""

