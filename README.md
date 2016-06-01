# Usage
This 'Backup to WebDav docker' will mount a webdav share, and uses rsync to sync the files to the webdav. Because we need the mount kernel commands this container needs to run __--privileged__!

This image can be found on [docker hub](https://hub.docker.com/r/daanoz/webdav-backup/).

The following 4 environment variables are required for the container to run:

    WEBDAV_URL=<webdavurl>
    WEBDAV_USER=<username>
    WEBDAV_PASS=<password>
    TARGET_DIR=<directory on the webdav share(if it doesn't exist it will be created)>

Optionally the rsync parameters can be overridden, by default it runs as:

    RSYNC_PARAMS=-rP --delete --no-whole-file --inplace

# Examples

Basic usage:

    docker run --privileged --rm -e "TARGET_DIR=backupdir/" -e "WEBDAV_URL=http://webdavurl" -e "WEBDAV_USER=username" -e "WEBDAV_PASS=password" -v /home/user/datatobackup/:/mnt/backup:ro daanoz/webdav-backup:latest

To run as daily backupscript retaining 7 days of history:

        #!/bin/bash
        # Get day of the week
        DOW=$(date +%u)

        docker pull daanoz/webdav-backup:latest
        docker run --privileged --rm --name webdav-backup --env-file ./webdav.env.list -e "TARGET_DIR=backdir/$DOW/" -v /home/user/datatobackup/:/mnt/backup:ro daanoz/webdav-backup:latest
