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

    curl -O https://raw.githubusercontent.com/swappsco/wp-backup/master/backup.sh
    chmod +x backup.sh
    sudo mv backup.sh /usr/bin/backup

*****
Usage
*****

Full Version
""""""""""""

.. code-block:: bash

    backup $HOSTNAME $FOLDER_TO_STORE $LOCAL_BACKUPS_PATH $DESTINATION_BACKUPS_PATH $PROJECTS_FOLDER

* **HOSTNAME** is the name you want to provide to the folder where the backups will be stored.
* **FOLDER_TO_STORE** name of the folder where the backup will be saved (e.g daily, monthly, my_custom_name)
* **LOCAL_BACKUPS_PATH** temp folder where backups will be saved
* **$DESTINATION_BACKUPS_PATH** folder where the backups will be saved
* **$PROJECTS_FOLDER** location path of the wordpress applications


Simplified version
""""""""""""""""""

.. code-block:: bash

    backup $HOSTNAME $FOLDER_TO_STORE


*********************
Crontab configuration
*********************

.. code-block:: bash

    crontab -e

Specify in the crontab the command to run to the required time. In this example we are configuring 3 daily, weekly and monthly backups.

.. code-block:: bash

    0 3 * * * /usr/bin/backup hostname daily
    0 4 * * 0 /usr/bin/backup hostname weekly
    0 5 1 * 6 /usr/bin/backup hostname monthly

********************************
Email notifications with mailgun
********************************

Create a file `~/.backupvars` and include the information for mail notifications, for example:

.. code-block:: bash
    
    MAILGUN_API_KEY="key-API"
    MAILGUN_DOMAIN="example.com"
    MAILGUN_EMAIL_FROM="Backups<backups@example.com"
    MAILGUN_EMAIL_TO="devops@example.com"
