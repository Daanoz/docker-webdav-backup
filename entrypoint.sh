#!/bin/bash

if [[ -n "$WEBDAV_URL" ]] && [[ -n "$WEBDAV_USER" ]] && [[ -n "$WEBDAV_PASS" ]] && [[ -n "$TARGET_DIR" ]]
then
	echo "Starting mount of $WEBDAV_URL"
else
	echo "Not all required environment variables are set"
	exit 1
fi

echo "$WEBDAV_URL /mnt/webdav davfs user,noauto,uid=root,file_mode=600,dir_mode=700 0 1" >> /etc/fstab
echo "/mnt/webdav $WEBDAV_USER \"$WEBDAV_PASS\"" >> /etc/davfs2/secrets

mount /mnt/webdav

mkdir -p /mnt/webdav/$TARGET_DIR

echo "Starting sync procedure to $TARGET_DIR"
rsync $RSYNC_PARAMS /mnt/backup/ /mnt/webdav/$TARGET_DIR

echo "Waiting davfs to trigger for file upload, continue in 10s"
sleep 10

# unmount, and wait for transfers
umount.davfs /mnt/webdav

echo "Starting credential cleanup"
echo "" > /etc/davfs2/secrets
export WEBDAV_USER=""
export WEBDAV_PASS=""
echo "Done!"
