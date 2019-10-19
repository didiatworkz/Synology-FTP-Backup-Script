# Synology FTP Backup Script

![image1](https://raw.githubusercontent.com/didiatworkz/Synology-FTP-Backup-Script/master/_resources/image1.png)

With this script it is possible to create an FTP backup of a web server and archive it directly on the Synology NAS.

## How to use

- Goto the Task Manager in the settings menu
![step1](https://raw.githubusercontent.com/didiatworkz/Synology-FTP-Backup-Script/master/_resources/step1.jpg)

- Create a new task as root user
![step2](https://raw.githubusercontent.com/didiatworkz/Synology-FTP-Backup-Script/master/_resources/step2.jpg)

- Copy the script into the textarea and change the variables
![step3](https://raw.githubusercontent.com/didiatworkz/Synology-FTP-Backup-Script/master/_resources/step3.jpg)

## Variables

_HOSTNAME="customer.myserver.tld"
_USERLOGIN="username"
_PASSWORD="password"

_BACKUP_NAME="MyBackupJob"
_REMOTE_DIR="path/to/dir"
_LOCAL_DIR="/volume1/Backup"
_REMOVE_DAYS="30"

## Features

The script automatically creates all required folders and files. It also checks that the log files are not larger than 50MB. If the files are larger, they will be moved.
It is checked whether there are older backups and these are deleted if necessary, so that the NAS does not run out of hard disk space.

# Caution

I don't take over any liability for possible damages which caused by the script!
