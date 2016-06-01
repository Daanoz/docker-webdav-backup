# Usage
This 'Backup to WebDav docker' will mount a webdav share, and uses RSYNC to sync the files to the webdav. Because we need the mount kernal commands this container needs to run ##--privileged##!

The following 4 environment variables are required for the container to run:

  WEBDAV_URL=<webdavurl>
  WEBDAV_USER=<username>
  WEBDAV_PASS=<password>
  TARGET_DIR=<directory on the webdav share(if it doesn't exist it will be created)>

Optionally the rsync parameters can be overridden, by default it runs as:

  RSYNC_PARAMS=-rP --delete --no-whole-file --inplace

Basic usage:

  docker run --privileged -d --name webdav-backup --env-file ./webdav.env.list daanoz/webdav-backup:latest
