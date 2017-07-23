#!/bin/bash
source $HOME/.backupvars
DAY=$(date +"%a")
HOSTNAME=$1
FOLDER_TO_STORE=${2-DAY}
LOCAL_BACKUPS_PATH=${3-"/home/ubuntu/backups/auto"}
DESTINATION_BACKUPS_PATH=${4-"/mnt/disk/backups/auto"}
PROJECTS_FOLDER=${5-"/srv/apps"}
NOW=`date`

for f in $PROJECTS_FOLDER/*; do
  if [ -d "$f" ]; then
     cd $f
     project_name="${PWD##*/}"
     if [ "$project_name" != "certbot" ]; then
        echo $project_name
        mkdir -p $LOCAL_BACKUPS_PATH/$FOLDER_TO_STORE
        wp db export $LOCAL_BACKUPS_PATH/$project_name.sql
  echo $LOCAL_BACKUPS_PATH/$FOLDER_TO_STORE/files_$project_name.tgz
  tar czvf $LOCAL_BACKUPS_PATH/$FOLDER_TO_STORE/files_$project_name.tgz . -P --exclude='*.tgz' --exclude='*.sql' --exclude='*.gz' --exclude='*.zip' --exclude='*.tar' --exclude='*.sql' --exclude='*.zip' --exclude='wp-content/cache/*' --exclude='.git/*'
  tar czvf $LOCAL_BACKUPS_PATH/$FOLDER_TO_STORE/db_$project_name.tgz $LOCAL_BACKUPS_PATH/$project_name.sql
  ssh backup mkdir -p $DESTINATION_BACKUPS_PATH/$HOSTNAME/$FOLDER_TO_STORE
  scp $LOCAL_BACKUPS_PATH/$FOLDER_TO_STORE/files_$project_name.tgz backup:$DESTINATION_BACKUPS_PATH/$HOSTNAME/$FOLDER_TO_STORE/
  scp $LOCAL_BACKUPS_PATH/$FOLDER_TO_STORE/db_$project_name.tgz backup:$DESTINATION_BACKUPS_PATH/$HOSTNAME/$FOLDER_TO_STORE/
     fi
  fi

done

rm -rf $LOCAL_BACKUPS_PATH

if [ -n "$MAILGUN_API_KEY" ]; then
  curl -s --user "api:$MAILGUN_API_KEY" \
      "https://api.mailgun.net/v3/$MAILGUN_DOMAIN/messages" \
      -F from="$MAILGUN_EMAIL_FROM" \
      -F to="$MAILGUN_EMAIL_TO" \
      -F subject="$FOLDER_TO_STORE backup completed" \
      -F text="Hey there,  The $FOLDER_TO_STORE backup for $HOSTNAME was completed at $NOW"
fi

