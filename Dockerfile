FROM ubuntu:latest
MAINTAINER kneave <keegan.neave@outlook.com>
# Based on source from Adrian Hobbs <adrianhobbs@gmail.com>, github.com/hobbsAU

ENV DEBIAN_FRONTEND noninteractive
ENV TVH_BRANCH master

# Update packages in base image, avoid caching issues by combining statements, install build software and deps
RUN     apt-get update && apt-get install -y build-essential git pkg-config libssl-dev bzip2 wget libavahi-client-dev zlib1g-dev libavcodec-dev libavutil-dev libavformat-dev libswscale-dev python gettext libavahi-client3 cmake bzip2 && \
        rm -rf /var/lib/apt/lists/*
        #Install tvheadend from git, cleaning up and removing all build footprint
RUN     git clone https://github.com/tvheadend/tvheadend.git /opt/tvheadend && \
        cd /opt/tvheadend && \
        git checkout $TVH_BRANCH
RUN     /opt/tvheadend/configure --enable-hdhomerun_static --enable-libffmpeg_static
RUN     cd /opt/tvheadend && make && make install && \
        cd /opt && rm -rf /opt/tvheadend
        #Clean up removing all build packages and dev libraries, remove unused dependencies and temp files
RUN     apt-get purge -yqq build-essential git pkg-config libssl-dev wget libavahi-client-dev zlib1g-dev libavcodec-dev libavutil-dev libavformat-dev libswscale-dev python gettext && \
        apt-get autoremove --purge -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add a user to run as non root
#RUN    adduser --disabled-password --gecos '' hts

EXPOSE 9981 9982

ENTRYPOINT ["/usr/local/bin/tvheadend"]
CMD ["-c","/config"]
