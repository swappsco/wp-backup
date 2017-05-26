================
Wordpress Backup
================

Script to backup database and files and send them to a backup server.

Assumptions:
""""""""""""

* You have a backup server and multiple servers with Wordpress websites.
* All the Wordpress projects folders are located in the same parent folder.
* The source server can establish a SSH connection to the destination server without authentication. (SSH-KEY approved)


******
Usage:
******

/usr/bin/backup $hostname $backup_path $apps_path

$hostname is the name you want to provide to the folder where the backups will be stored.
$backup_path folder where the backups will be saved
$apps_path locations of the wordpress applications
