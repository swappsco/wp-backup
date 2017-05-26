================
Wordpress Backup
================

Script to backup database and files and send them to a backup server.

Assumptions:
""""""""""""

* You have a backup server and multiple servers with Wordpress websites.
* All the Wordpress projects folders are located in the same parent folder.
* The source server can establish a SSH connection to the destination server without authentication. (SSH-KEY approved)

************
Installation
************

.. code-block:: bash

    wget https://raw.githubusercontent.com/swappsco/wp-backup/master/backup.sh
    chmod +x backup.sh
    sudo mv backup.sh /usr/bin/backup

*****
Usage
*****

.. code-block:: bash

    backup $hostname $backup_path $apps_path

* **$hostname** is the name you want to provide to the folder where the backups will be stored.
* **$backup_path** folder where the backups will be saved
* **$apps_path** locations of the wordpress applications


*********************
Crontab configuration
*********************

.. code-block:: bash

    crontab -e

Specify in the crontab the command to run to the required time

.. code-block:: bash

    0 3 * * * /usr/bin/backup hostname /backup/ /var/www/
