#!/bin/bash
DAY=$(date +"%a")
HOSTNAME=$1
LOCAL_BACKUPS_PATH=${2-"/home/ubuntu/backups/auto"}
DESTINATION_BACKUPS_PATH=${3-"/mnt/disk/backups/auto"}
PROJECTS_FOLDER=${4-"/srv/apps"}

for f in $PROJECTS_FOLDER/*; do
  if [ -d "$f" ]; then
     cd $f
     project_name="${PWD##*/}"
     if [ "$project_name" != "certbot" ]; then
        echo $project_name
        mkdir -p $LOCAL_BACKUPS_PATH/$DAY
        wp db export $LOCAL_BACKUPS_PATH/$project_name.sql
  echo $LOCAL_BACKUPS_PATH/$DAY/files_$project_name.tgz
  tar czvf $LOCAL_BACKUPS_PATH/$DAY/files_$project_name.tgz wp-content/uploads -P
  tar czvf $LOCAL_BACKUPS_PATH/$DAY/db_$project_name.tgz $LOCAL_BACKUPS_PATH/$project_name.sql
  ssh backup mkdir -p $DESTINATION_BACKUPS_PATH/$HOSTNAME/$DAY
  scp $LOCAL_BACKUPS_PATH/$DAY/files_$project_name.tgz backup:$DESTINATION_BACKUPS_PATH/$HOSTNAME/$DAY/
  scp $LOCAL_BACKUPS_PATH/$DAY/db_$project_name.tgz backup:$DESTINATION_BACKUPS_PATH/$HOSTNAME/$DAY/
     fi
  fi

rm -rf $LOCAL_BACKUPS_PATH
done
