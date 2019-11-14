#!/bin/bash

set -e

if [[ -n "$WEBDAV_URL" ]] && [[ -n "$WEBDAV_USER" ]] && [[ -n "$WEBDAV_PASS" ]]
then
	echo "Starting mount of $WEBDAV_URL"
else
	echo "Not all required environment variables are set"
	exit 1
fi

echo "$WEBDAV_URL /mnt/webdav davfs user,noauto,uid=root,file_mode=600,dir_mode=700 0 1" >> /etc/fstab
echo "/mnt/webdav $WEBDAV_USER \"$WEBDAV_PASS\"" >> /etc/davfs2/secrets

mount /mnt/webdav

BACKUP_FROM=${BACKUP_FROM:=/mnt/webdav/}
BACKUP_TO=${BACKUP_TO:=/mnt/backup/}

echo "Starting sync procedure from ${BACKUP_FROM} to ${BACKUP_TO}"
rsync $RSYNC_PARAMS ${BACKUP_FROM} ${BACKUP_TO}

echo "Syncing filesystems"
sync

# unmount, and wait for transfers
umount.davfs /mnt/webdav

echo "Starting credential cleanup"
echo "" > /etc/davfs2/secrets
export WEBDAV_USER=""
export WEBDAV_PASS=""

echo "Done!"

