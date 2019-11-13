# Usage
This 'Backup to WebDav docker' will mount a webdav share, and uses rsync to sync the files to the webdav. Because we need the mount kernel commands this container needs to run __--privileged__!

This image can be found on [docker hub](https://hub.docker.com/r/fdock/webdav-backup/).

# Environment Variables

The following 5 environment variables are required for the container to run:

    WEBDAV_URL=<webdavurl>
    WEBDAV_USER=<username>
    WEBDAV_PASS=<password>
    BACKUP_FROM=<source>, e.g. /mnt/webdav/
    BACKUP_TO=<dest>, e.g. /mnt/backup/

Optionally the rsync parameters can be overridden, by default it runs as:

    RSYNC_PARAMS=-rP --delete --no-whole-file --inplace --progress

# Direction of Synchronization

Using the variables BACKUP_FROM and BACKUP_TO you can freely define the direction of synchronization. The WebDAV source is always mounted at /mnt/webdav. If you mount your backup volume at /mnt/backup and choose BACKUP_FROM=/mnt/webdav/ and BACKUP_TO=/mnt/backup/ you sync your data from the WebDAV server.

# Examples

Basic usage:

    docker run --privileged --rm -e "TARGET_DIR=backupdir/" -e "WEBDAV_URL=http://webdavurl" -e "WEBDAV_USER=username" -e "WEBDAV_PASS=password" -v /home/user/datatobackup/:/mnt/backup:ro daanoz/webdav-backup:latest

To run as daily backupscript retaining 7 days of history:

        #!/bin/bash
        # Get day of the week
        DOW=$(date +%u)

        docker pull daanoz/webdav-backup:latest
        docker run --privileged --rm --name webdav-backup --env-file ./webdav.env.list -e "TARGET_DIR=backdir/$DOW/" -v /home/user/datatobackup/:/mnt/backup:ro daanoz/webdav-backup:latest

# Credits

This is a fork of [daanoz/docker-webdav-backup](https://github.com/daanoz/docker-webdav-backup) with some minor additions (ca-certificates, BACKUP_FROM/BACKUP_TO) and based on the latest Ubuntu image.

