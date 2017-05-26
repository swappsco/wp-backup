#!/bin/bash
DAY=$(date +"%a")
HOSTNAME=$1
BACKUPS_PATH=$2
PROJECTS_FOLDER=$3
for f in $PROJECTS_FOLDER/*; do
  if [ -d "$f" ]; then
     cd $f
     project_name="${PWD##*/}"
     if [ "$project_name" != "certbot" ]; then
        echo $project_name
        mkdir -p $BACKUPS_PATH/$DAY
        wp db export $BACKUPS_PATH/$project_name.sql
	echo $BACKUPS_PATH/$DAY/files_$project_name.tgz
	tar czvf $BACKUPS_PATH/$DAY/files_$project_name.tgz wp-content/uploads -P
	tar czvf $BACKUPS_PATH/$DAY/db_$project_name.tgz $BACKUPS_PATH/$project_name.sql
	ssh backup mkdir -p $BACKUPS_PATH/$HOSTNAME/$DAY
	scp $BACKUPS_PATH/$DAY/files_$project_name.tgz backup:$BACKUPS_PATH/$HOSTNAME/$DAY/
	scp $BACKUPS_PATH/$DAY/db_$project_name.tgz backup:$BACKUPS_PATH/$HOSTNAME/$DAY/
     fi
  fi

rm -rf $BACKUPS_PATH
done
