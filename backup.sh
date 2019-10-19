#!/bin/bash
# Created by didiatworkz
# Synology FTP Backup Script
# --------------------------
# Copy this Code to the Task Scheduler and run as root
# --------------------------

# --------------------------
# Remote Server authentication
_HOSTNAME="customer.myserver.tld"
_USERLOGIN="username"
_PASSWORD="password"

# --------------------------
# Jobname
_BACKUP_NAME="MyBackupJob"

# --------------------------
# Remote Server folder
# Example: remote_dir="*" = Full Backup
# Example: remote_dir="folder1" = Backup folder1 only
# Important: Don't use slash at the begin and the end!
# ( "/f1/f2/f3/" <- Wrong | "f1/f2/f3" <- Right )
_REMOTE_DIR="path/to/dir"

# --------------------------
# Local Synology folder
# Example: "/volume1/Backup"
# Backup is in this example a shared Folder
_LOCAL_DIR="/volume1/Backup"

# --------------------------
# Clean older backups in Days
# Example: "30"
_REMOVE_DAYS="30"




# ------------------------------------------------------------------------
# ------------------------------------------------------------------------
# ####    DO NOT EDIT ABOVE THIS LINE    ####
# ------------------------------------------------------------------------
# ------------------------------------------------------------------------

_LOCAL_DIR="${_LOCAL_DIR}/${_BACKUP_NAME}"

logFile(){
  echo "$(date "+%Y-%m-%d %H:%M:%S") [BACKUP JOB: $_BACKUP_NAME] $1"
  echo "$(date "+%Y-%m-%d %H:%M:%S") [BACKUP JOB: $_BACKUP_NAME] $1" >> "$_LOCAL_DIR/$_BACKUP_NAME.log"
}
changeLogFile(){
  if [ -f "$_LOCAL_DIR/$_BACKUP_NAME.log.3" ]; then
      rm -rf "$_LOCAL_DIR/$_BACKUP_NAME.log.3"
  fi
  if [ -f "$_LOCAL_DIR/$_BACKUP_NAME.log.2" ]; then
      mv "$_LOCAL_DIR/$_BACKUP_NAME.log.2" "$_LOCAL_DIR/$_BACKUP_NAME.log.3"
  fi
  if [ -f "$_LOCAL_DIR/$_BACKUP_NAME.log.1" ]; then
      mv "$_LOCAL_DIR/$_BACKUP_NAME.log.1" "$_LOCAL_DIR/$_BACKUP_NAME.log.2"
  fi
  mv "$_LOCAL_DIR/$_BACKUP_NAME.log" "$_LOCAL_DIR/$_BACKUP_NAME.log.1"
  logFile "Move .log File"
}

if [ -d "$_LOCAL_DIR/$_BACKUP_NAME"_TEMP ]; then
    rm "$_LOCAL_DIR/$_BACKUP_NAME"_TEMP
fi
if [ ! -d "$_LOCAL_DIR" ]; then
  mkdir -p "$_LOCAL_DIR"
fi
if [ ! -f "$_LOCAL_DIR/$_BACKUP_NAME.log" ]; then
    touch "$_LOCAL_DIR/$_BACKUP_NAME.log"
fi
logFile "Start Backup"
if [[ $(find "$_LOCAL_DIR/$_BACKUP_NAME.log" -type f -size +52428800c 2>/dev/null) ]]; then
    changeLogFile
fi
logFile "Copy Files"
wget -m ftp://"$_USERLOGIN"\:"$_PASSWORD"@"$_HOSTNAME"/"$_REMOTE_DIR" -P "$_LOCAL_DIR/$_BACKUP_NAME"_TEMP -a "$_LOCAL_DIR/$_BACKUP_NAME.log"
logFile "Compress Backup"
cd "$_LOCAL_DIR/$_BACKUP_NAME"_TEMP/"$_HOSTNAME"
tar -zcvf "$_LOCAL_DIR"/"$_BACKUP_NAME"_"$(date "+%Y-%m-%d_%H%M%S")".tar.gz --exclude='.listing' * >> "$_LOCAL_DIR/$_BACKUP_NAME.log"
cd ../../
logFile "Remove TEMP Folder"
rm -r "$_LOCAL_DIR/$_BACKUP_NAME"_TEMP >> "$_LOCAL_DIR/$_BACKUP_NAME.log"
find "$_LOCAL_DIR" -name '*.tar.gz' -mtime +"$_REMOVE_DAYS" -exec rm -rf {} \;
logFile "Backup complete!"
echo "################################################" >> "$_LOCAL_DIR/$_BACKUP_NAME.log"
