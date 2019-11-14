FROM ubuntu
MAINTAINER Daan Sieben

RUN apt-get update && \
  	apt-get -y autoremove && \
  	apt-get clean && \
  	apt-get install -y \
  	 davfs2 rsync ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /mnt/webdav/
RUN mkdir /mnt/backup/

ENV RSYNC_PARAMS "--archive --numeric-ids --delete --delete-delay"

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh
ENTRYPOINT /entrypoint.sh
